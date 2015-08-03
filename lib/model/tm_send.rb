# -*- coding: utf-8 -*-
require_relative '../model'

module TypedRb
  module Model
    # message send
    class TmSend < Expr
      attr_accessor :receiver, :message, :args, :block
      def initialize(receiver, message, args, node)
        super(node)
        @receiver = receiver
        @message = message
        @args = args
        @block = nil
      end

      def with_block(block)
        @block = block
      end

      def rename(from_binding, to_binding)
        # rename receiver
        if !@receiver.nil? && @receiver != :self
          @receiver = @receiver.rename(from_binding, to_binding)
        elsif @receiver.nil? && @message == from_binding.to_sym
          @message = to_binding.to_sym
        end

        # rename default args
        @args = @args.map { |arg| arg.rename(from_binding, to_binding) }
        self
      end

      def check_type(context)
        if receiver.nil? && message == :ts
          # ignore, => type annotation
        elsif message == :new && !singleton_object_type(receiver, context).nil?
          check_instantiation(context)
        elsif receiver == :self || receiver.nil?
          # self.m(args), m(args), m
          check_type_no_explicit_receiver(context)
        else
          # x.m(args)
          check_type_explicit_receiver(context)
        end
      end

      def singleton_object_type(receiver,context)
        receiver_type = if (receiver.nil? || receiver == :self)
                          context.get_type_for(:self)
                        else
                          receiver.check_type(context)
                        end
        if receiver_type.is_a?(Types::TySingletonObject)
          receiver_type
        else
          nil
        end
      end

      # we received new, but we look for initialize in the class,
      # not the singleton class.
      # we then run the regular application,
      # but we return the class type instead of the return type
      # for the constructor application (should be unit/nil).
      def check_instantiation(context)
        self_type = singleton_object_type(receiver,context).as_object_type
        function_klass_type, function_type = self_type.find_function_type(:initialize)
        if function_type.nil?
          error_message = "Error typing message, type information for #{receiver_type} constructor found."
          fail TypeCheckError, error_message
        else
          # function application
          @message = :initialize
          begin
            check_application(self_type, function_type, context)
          rescue TypeCheckError => error
            raise error if function_klass_type == self_type.ruby_type
          end
          self_type
        end
      end

      def check_type_no_explicit_receiver(context)
        # local variables take precedence over message sending
        if context.get_type_for(message) && args.size == 0
          context.get_type_for(message)
        else
          self_type = context.get_type_for(:self) # check message in self type -> application
          if self_type.is_a?(Types::Polymorphism::TypeVariable) # Existential type (Module)
            # TODO: what can we do if this is the inclusion of a module?
            arg_types = args.map { |arg| arg.check_type(context) }
            self_type.add_message_constraint(message, arg_types)
          else
            function_klass_type, function_type = self_type.find_function_type(message)
            begin
              if function_type.nil?
                error_message = "Error typing message, type information for #{self_type}:#{message} found."
                fail TypeCheckError error_message
              elsif cast?(function_klass_type)
                check_casting(context)
              elsif module_include_implementation?(function_klass_type)
                check_module_inclusions(self_type, context)
              else
                # function application
                check_application(self_type, function_type, context)
              end
            rescue TypeCheckError => error
              if  !(function_klass_type == :main && self_type.is_a?(Types::TyTopLevelObject)) && function_klass_type != self_type.ruby_type
                Types::TyDynamic.new(Object)
              elsif function_klass_type == :main && self_type.is_a?(Types::TyTopLevelObject) && function_type.nil?
                Types::TyDynamic.new(Object)
              else
                raise error
              end
            end
          end
        end
      end

      def check_type_explicit_receiver(context)
        receiver_type = receiver.check_type(context)
        if receiver_type.is_a?(Types::Polymorphism::TypeVariable)
          arg_types = args.map { |arg| arg.check_type(context) }
          receiver_type.add_message_constraint(message, arg_types)
        elsif receiver_type.is_a?(Types::TyGenericSingletonObject) && (message == :call)
          # Application of types accept a type class or a string with a type description
          arg_types = parse_type_application_arguments(args, context)
          check_type_application_to_generic(receiver_type, arg_types)
        elsif receiver_type.is_a?(Types::TyFunction) && (message == :[] || message == :call)
          check_lambda_application(receiver_type, context)
        else
          function_klass_type, function_type = receiver_type.find_function_type(message)
          begin
            if function_type.nil?
              error_message = "Error typing message, type information for #{receiver_type}:#{message} found."
              fail TypeCheckError, error_message
            elsif module_include_implementation?(function_klass_type)
              check_module_inclusions(receiver_type, context)
            else
              # function application
              check_application(receiver_type, function_type, context)
            end
          rescue TypeCheckError => error
            if function_klass_type != receiver_type.ruby_type
              Types::TyDynamic.new(Object)
            else
              raise error
            end
          end
        end
      end

      def parse_type_application_arguments(arguments, context)
        arguments.map do |argument|
          if argument.is_a?(Model::TmString)
            type = TypeSignature::Parser.parse(argument.node.children.first)
            # TODO: do this recursively in the case of nested generic type
            # TODO: do we need it at all?
            if type.is_a?(Hash) && type[:kind] == :type_var
              type[:type] = "type_app_#{type_application_counter}"
            end

            klass = if type.is_a?(Hash) && type[:kind] == :generic_type
                      Object.const_get(type[:type])
                    else
                      nil
                    end
            Types::Type.parse(type, klass)
          else
            argument.check_type(context)
          end
        end
      end

      def type_application_counter
        @type_application_counter ||= 0
        @type_application_counter += 1
      end

      def check_type_application_to_generic(generic_type, args)
        generic_type.materialize(args)
      end

      def check_application(receiver_type, function_type, context)
        if function_type.is_a?(Types::TyDynamicFunction)
          function_type.to
        else
          formal_parameters = function_type.from
          method = receiver_type.resolve_ruby_method(message)
          parameters_info = method.parameters
          TypedRb.log(binding, :debug, "Checking function application #{receiver_type}::#{method.name}( #{parameters_info} )")
          check_args_application(parameters_info, formal_parameters, args, context)
          if @block
            block_type = @block.check_type(context)
            function_type.with_block_type(block_type).compatible?(block_type, :lt)
          end
          function_type.to
        end
      end

      def check_lambda_application(lambda_type, context)
        lambda_type.check_args_application(args, context).to
      end

      def check_args_application(parameters_info, formal_parameters, actual_arguments, context)
        parameters_info.each_with_index do |(require_info, arg_name), index|
          actual_argument = actual_arguments[index]
          formal_parameter_type = formal_parameters[index]
          if formal_parameter_type.nil?
            fail TypeCheckError, "Missing information about argument #{arg_name} in #{receiver}##{message}"
          end
          if actual_argument.nil? && require_info != :opt && require_info != :rest
            fail TypeCheckError, "Missing mandatory argument #{arg_name} in #{receiver}##{message}"
          else
            if require_info == :rest
              rest_type = formal_parameter_type.type_vars.first
              formal_parameter_type = if rest_type.bound
                                        rest_type.bound
                                      else
                                        rest_type
                                      end
              actual_arguments[index..-1].each do |actual_argument|
                unless actual_argument.check_type(context).compatible?(formal_parameter_type, :lt)
                  error_message = "#{formal_parameter_type} expected, #{actual_argument_type} found"
                  fail TypeCheckError, error_message
                end
              end
              break
            else
              unless actual_argument.nil? # opt if this is nil
                actual_argument_type = actual_argument.check_type(context)
                unless actual_argument_type.compatible?(formal_parameter_type, :lt)
                  error_message = "#{formal_parameter_type} expected, #{actual_argument_type} found"
                  fail TypeCheckError, error_message
                end
              end
            end
          end
        end
      end

      def cast?(function_klass_type)
        function_klass_type == BasicObject && message == :cast
      end

      def check_casting(context)
        from = args[0].check_type(context)
        to = parse_type_application_arguments([args[1]], context).first.as_object_type
        TypedRb.log(binding, :info, "Casting #{from} into #{to}")
        to
      end

      def module_include_implementation?(function_klass_type)
        function_klass_type == Module && message == :include
      end

      def check_module_inclusions(self_type, context)
        args.map do |arg|
          arg.check_type(context)
        end.each do |module_type|
          if module_type.is_a?(Types::TyExistentialType)
            module_type.check_inclusion(self_type)
          else
            error_message = "Module type expected for inclusion in #{self_type}, #{module_type} found"
            fail TypeCheckError, error_message
          end
        end
        self_type
      end
    end
  end
end
