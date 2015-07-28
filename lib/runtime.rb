require_relative 'type_signature/parser'
require_relative './types'

class BasicObject

  def ts signature
    ::TypedRb.log(binding, :debug,  "Parsing signature: #{signature} and #{signature} and #{2}")
    if $TYPECHECK
      parametric_type_prefix = /\s*(module|class|type)\s*/
      if signature.index(parametric_type_prefix) == 0
        type_signature = signature.split(parametric_type_prefix).last
        generic_type = ::TypedRb::TypeSignature::Parser.parse(type_signature).first
        TypeRegistry.register_generic_type_information(generic_type)
      else
        method, signature = signature.split(/\s+\/\s+/)

        kind, receiver, message = if method.index('#')
                                    [:instance] + method.split('#')
                                  elsif method.index('.')
                                    [:class] + method.split('.')
                                  else
                                    fail ::TypedRb::Types::TypeParsingError,
                                    "Error parsing receiver, method signature: #{signature}"
                                  end

        if receiver == ''
          if self.object_id == ::TOPLEVEL_BINDING.receiver.object_id
            receiver = 'main'
          elsif self.instance_of?(::Class) || self.instance_of?(::Module)
            receiver = if name.nil?
                         # singleton classes
                         self.to_s.match(/Class:(.*)>/)[1]
                       else
                         self.name
                       end
          else
            receiver = self.class.name
          end
        end

        kind = :"#{kind}_variable" if message.index('@')

        type_ast = ::TypedRb::TypeSignature::Parser.parse(signature)

        TypeRegistry.register_type_information(kind, receiver, message, type_ast)
      end
    end
  rescue ::StandardError => ex
    puts ex.backtrace.join("\n")
    raise ::StandardError, "Error parsing type signature '#{type_signature}': #{ex.message}"
  end

  class TypeRegistry
    class << self

      ts '.clear / -> unit'
      def clear
        generic_types_registry.clear
        generic_types_parser_registry.clear
        registry.clear
        parser_registry.clear
      end

      ts '.register_type_information / Symbol -> String -> String -> Object -> unit'
      def register_type_information(kind, receiver, method, type_ast)
        methods_for(kind, receiver)[method] = type_ast
      end

      ts '.register_generic_type_information / Hash[Object][Object] -> unit'
      def register_generic_type_information(generic_type_information)
        if generic_types_parser_registry[generic_type_information[:type]]
          fail ::TypedRb::Types::TypeParsingError,
          "Duplicated generic type definition for #{generic_type_information[:type]}"
        else
          generic_types_parser_registry[generic_type_information[:type]] = generic_type_information
        end
      end

      ts '.find_generic_type / Class -> TypedRb::Types::TyGenericSingletonObject'
      def find_generic_type(type)
        @generic_types_registry[type]
      end

      ts '.type_vars_for / Class -> Array[TypedRb::Types::Polymorphism::TypeVariable]'
      def type_vars_for(klass)
        singleton_object = find_generic_type(klass)
        if singleton_object
          singleton_object.type_vars.map do |type_var|
            ::TypedRb::Types::Polymorphism::TypeVariable.new(type_var.variable,
                                                             :upper_bound => type_var.upper_bound,
                                                             :lower_bound => type_var.lower_bound,
                                                             :gen_name => false)
          end
        else
          []
        end
      end

      ts '.type_var? / Class -> String -> Boolean'
      def type_var?(klass, variable)
        singleton_object = generic_types_registry[klass]
        if singleton_object
          singleton_object.type_vars.any? do |type_var|
            type_var.variable == variable
          end
        else
          false
        end
      end

      ts '.find / Symbol -> Class -> String -> TypedRb::Types::TyFunction'
      def find(kind, klass, message)
        class_data = registry[[kind, klass]]
        if class_data
          # TODO: What should we when the class is in the registry but the method is missing?
          # The class has been marked but only partially?
          # Dynamic invokation or error?
          # Maybe an additional @dynamic annotation can be added to distinguish the desired outcome.
          # Preferred outcome right now is nil to catch errors in unification, safer assumption.
          #class_data[message.to_s] || nil # ::TypedRb::Types::TyDynamicFunction.new(klass, message)
          class_data[message.to_s] || ::TypedRb::Types::TyDynamicFunction.new(klass, message)
        elsif kind == :instance_variable || kind == :class_variable
          nil
        else
          #if registered?(klass)
          #  nil
          #else
            ::TypedRb::Types::TyDynamicFunction.new(klass, message)
          #end
        end
      end

      ts '.registered / Class -> Boolean'
      def registered?(klass)
        registry.keys.map(&:last).include?(klass)
      end

      ts '.normalize_types! / -> unit'
      def normalize_types!
        normalize_generic_types!
        normalize_methods!
      end

      protected

      ts '.registry / -> Hash[ Array[Object] ][ Hash[String][TypedRb::Types::TyFunction] ]'
      def registry
        @registry ||= {}
        @registry
      end

      ts '.generic_types_registry / -> Hash[Class][ TypedRb::Types::TyGenericSingletonObject ]'
      def generic_types_registry
        @generic_types_registry ||= {}
        @generic_types_registry
      end

      ts '.parser_registry / Hash[ String ][ Hash[String][Object] ]'
      def parser_registry
        @parser_registry ||= {}
        @parser_registry
      end

      ts '.generic_types_parser_registry / Hash[String][ Hash[Object][Object] ]'
      def generic_types_parser_registry
        @generic_types_parser_registry ||= {}
        @generic_types_parser_registry
      end

      ts '.methods_for / String -> String -> Hash[String][Object]'
      def methods_for(kind, receiver)
        method_registry = parser_registry[object_key(kind, receiver)] || {}
        parser_registry[object_key(kind, receiver)] = method_registry
        method_registry
      end

      ts '.normalize_generic_types! / -> unit'
      def normalize_generic_types!
        @generic_types_registry = generic_types_parser_registry.inject({}) do |acc, (_, info)|
          info[:type] = Object.const_get(info[:type])
          TypedRb.log(binding, :debug,  "Normalising generic type: #{info[:type]}")

          info[:parameters] = info[:parameters].map do |parameter|
            ::TypedRb::Types::Type.parse(parameter, info[:type])
          end
          acc[info[:type]] = ::TypedRb::Types::TyGenericSingletonObject.new(info[:type], info[:parameters])
          acc
        end
      end

      ts '.normalize_methods! / -> unit'
      def normalize_methods!
        @registry = {}
        parser_registry.each_pair do |kind_receiver, method_signatures|
          parts = kind_receiver.split('|')
          type = parts.take(1).first.to_sym
          klass_name = parts.drop(1).join('_')
          if klass_name == 'main'
            klass = :main
            all_instance_methods = TOPLEVEL_BINDING.public_methods + TOPLEVEL_BINDING.protected_methods + TOPLEVEL_BINDING.private_methods
            all_methods = TOPLEVEL_BINDING.receiver.class.public_methods + TOPLEVEL_BINDING.receiver.class.protected_methods + TOPLEVEL_BINDING.receiver.class.private_methods
          else
            klass = Object.const_get(klass_name)
            all_instance_methods = klass.public_instance_methods + klass.protected_instance_methods + klass.private_instance_methods
            all_methods = klass.public_methods + klass.protected_methods + klass.private_methods
          end

          method_signatures = method_signatures.inject({}) do |signatures_acc, (method, signature)|
            TypedRb.log(binding, :debug, "Normalizing method #{type}[#{klass}] :: #{method} / #{signature}")

            if type == :instance
              unless (all_instance_methods).include?(method.to_sym)
                fail ::TypedRb::Types::TypeParsingError,
                "Declared typed instance method '#{method}' not found for class '#{klass}'"
              end
            elsif type == :class
              unless all_methods.include?(method.to_sym)
                fail ::TypedRb::Types::TypeParsingError,
                "Declared typed class method '#{method}' not found for class '#{klass}'"
              end
            end
            signatures_acc[method] = normalize_signature!(klass, signature)
            signatures_acc
          end
          @registry[[type,klass]] = method_signatures
        end
      end

      ts '.normalize_signature! / Class -> String -> TypedRb::Types::TyFunction'
      def normalize_signature!(klass, type)
        ::TypedRb::Types::Type.parse(type, klass)
      end

      ts '.object_key / String -> String -> String'
      def object_key(kind, receiver)
        "#{kind}|#{receiver}"
      end
    end
  end
end

class Class
  ts '.call / Class... -> unit'
  def call(*types)
    self
  end
end
