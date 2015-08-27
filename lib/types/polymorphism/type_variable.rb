module TypedRb
  module Types
    module Polymorphism
      class TypeVariable

        attr_accessor :bound, :variable, :upper_bound, :lower_bound, :name, :node

        def initialize(var_name, options = {})
          gen_name = options[:gen_name].nil? ? true : options[:gen_name]
          @upper_bound = options[:upper_bound]
          @lower_bound = options[:lower_bound]
          @node = options[:node]
          @name = var_name
          @variable = gen_name ? Model::GenSym.next("TV_#{var_name}") : var_name
          @bound = nil
        end

        def add_constraint(relation, type)
          TypingContext.add_constraint(variable, relation, type)
        end

        def add_message_constraint(message, args)
          return_type = TypingContext.type_variable_for_message(variable, message)
          return_type.node = node
          # add constraint for this
          add_constraint(:send, args: args, return: return_type, message: message)
          # return return type
          return_type
        end

        def compatible?(type, relation = :lt)
          if @bound
            @bound.compatible?(type,relation)
          elsif incompatible_vars?(type)
            false
          else
            add_constraint(relation, type)
            true
          end
        end

        def constraints(register = TypingContext)
          register.constraints_for(variable).map { |(t, c)| [self, t, c] }
        end

        def check_type(_context)
          self
        end

        def bind(type)
          @bound = type
        end

        def apply_bindings(bindings_map)
          bound_var = bindings_map[variable]
          if bound_var
            self.bound = bound_var.bound
            self.upper_bound = bound_var.upper_bound
            self.lower_bound = bound_var.lower_bound
          end
          self
        end

        def unbind
          @bound = nil
        end

        def to_s
          "#{@variable}::#{@bound || '?'}"
        end

        private

        def incompatible_vars?(type)
          if type.is_a?(TypeVariable)
            left_var = bound || self
            right_var = type.bound || type

            left_var.is_a?(TypeVariable) &&
            right_var.is_a?(TypeVariable) &&
            left_var.variable != right_var.variable &&
            (TypingContext.bound_generic_type_var?(left_var) &&
             TypingContext.bound_generic_type_var?(right_var))
          end
        end
      end
    end
  end
end
