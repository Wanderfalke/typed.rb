module TypedRb
  module Languages
    module PolyFeatherweightRuby
      module Types

        class TypeParsingError < StandardError; end

        class TypingContext

          class << self
            def type_variables_register
              @type_variables_register ||= Polymorphism::TypeVariableRegister.new
            end

            def type_variable_for(type, variable, hierarchy)
              type_variables_register.type_variable_for(type, variable, hierarchy)
            end

            def type_variable_for_message(variable, message)
              type_variables_register.type_variable_for_message(variable, message)
            end

            def type_variable_for_abstraction(abs_kind, variable, context)
              type_variables_register.type_variable_for_abstraction(abs_kind, variable, context)
            end

            def all_constraints
              type_variables_register.all_constraints
            end

            def all_variables
              type_variables_register.all_variables
            end

            def add_constraint(variable, relation, type)
              type_variables_register.add_constraint(variable, relation, type)
            end

            def constraints_for(variable)
              type_variables_register.constraints[variable] || []
            end

            def push_context
              new_register = Polymorphism::TypeVariableRegister.new(@type_variables_register)
              @type_variables_register.children << new_register
              @type_variables_register = new_register
              new_register
            end

            def pop_context
              fail StandardError, 'Empty typing context stack, impossible to pop' if @type_variables_register.nil?
              last_register = @type_variables_register
              @type_variables_register = @type_variables_register.parent
              last_register
            end
          end

          # work with types
          def self.top_level
            TypingContext.new.add_binding!(:self, TyTopLevelObject.new)
          end

          def initialize(parent=nil)
            @parent = parent
            @bindings = {}
          end

          def add_binding(val,type)
            TypingContext.new(self).push_binding(val,type)
          end

          def add_binding!(val,type)
            push_binding(val,type)
          end

          def get_type_for(val)
            type = @bindings[val.to_s]
            if type.nil?
              @parent.get_type_for(val) if @parent
            else
              type
            end
          end

          def get_self
            @bindings['self']
          end

          def context_name
            "#{@bindings['self']}"
          end

          protected

          def push_binding(val,type)
            @bindings[val.to_s] = type
            self
          end
        end

        class Type
          def self.parse(type)
            fail TypeParsingError, 'Error parsing type: nil value.' if type.nil?
            if type == 'unit'
              TyUnit.new
            elsif type == 'Boolean'
              TyBoolean.new
            elsif type.is_a?(Array)
              parse_function_type(type.is_a?(Array) ? type : [type])
            else
              parse_object_type(type)
            end
          end

          # other_type is a meta-type not a ruby type
          def compatible?(other_type, relation = :lt)
            if other_type.instance_of?(Class)
              self.instance_of?(other_type) || other_type == TyError
            else
              relation = (relation == :lt ? :gt : lt)
              other_type.instance_of?(self.class, relation) || other_type.instance_of?(TyError)
            end
          end

          def self.parse_object_type(type)
            begin
              if type == :unit
                TyUnit.new
              else
                ruby_type = Object.const_get(type)
                TyObject.new(ruby_type)
              end
            rescue StandardError => e
              puts e.message
              #puts "ERROR"
              #puts type
              #puts type.inspect
              #puts "==========================================="
              fail TypeParsingError, "Unknown Ruby type #{type}"
            end
          end

          def self.parse_singleton_object_type(type)
            begin
              ruby_type = Object.const_get(type)
              TySingletonObject.new(ruby_type)
            rescue StandardError => e
              puts e.message
              #puts "ERROR"
              #puts type
              #puts type.inspect
              #puts "==========================================="
              fail TypeParsingError, "Unknown Ruby type #{type}"
            end
          end

          protected

          def self.parse_function_type(arg_types)
            return_type = parse(arg_types.pop)
            TyFunction.new(arg_types.map{ |arg| parse(arg) }, return_type)
          end
        end

        # load type files
        Dir[File.join(File.dirname(__FILE__),'types','*.rb')].each do |type_file|
          load(type_file)
        end

        # Aliases for different basic types

        class TyInteger < TyObject
          def initialize
            super(Integer)
          end
        end

        class TyFloat < TyObject
          def initialize
            super(Float)
          end
        end

        class TyString < TyObject
          def initialize
            super(String)
          end
        end

        class TyUnit < TyObject
          def initialize
            super(NilClass)
          end
        end
      end
    end
  end
end
