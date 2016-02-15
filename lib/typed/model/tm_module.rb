# -*- coding: utf-8 -*-
require_relative '../model'

module TypedRb
  module Model
    # Module expression
    class TmModule < Expr
      attr_reader :module_name, :body

      def initialize(module_name, body, node)
        super(node)
        @module_name = module_name
        @body = body
      end

      def check_type(context)
        module_ruby_type = Types::TypingContext.find_namespace(module_name)
        module_type = Runtime::TypeParser.parse_existential_object_type(module_ruby_type.name)
        Types::TypingContext.namespace_push(module_name)
        module_type.node = node
        module_typing_context = TmModule.with_local_context(module_type, node) do |_module_self_variable|
          context = context.add_binding(:self, module_type)
          body.check_type(context) if body
        end
        Types::TypingContext.namespace_pop
        module_type.local_typing_context = module_typing_context
        unification = Types::Polymorphism::Unification.new(module_type.local_typing_context.all_constraints,
                                                           :allow_unbound_receivers => true)
        unification.run
        if(module_type.is_a?(TypedRb::Types::TyGenericExistentialType))
          module_type.clean_dynamic_bindings
        end
        module_type
      end

      def self.with_local_context(module_type, node)
        Types::TypingContext.push_context(:module)
        # Deal with upper/lower bounds here if required
        module_self_variable = Types::TypingContext.type_variable_for(module_type.ruby_type, :module_self, [module_type.ruby_type])
        module_self_variable.node = node
        module_self_variable.module_type = module_type
        module_type.self_variable = module_self_variable

        if(module_type.is_a?(TypedRb::Types::TyGenericExistentialType))
          module_type.type_vars.each do |type_var|
            type_var = Types::TypingContext.type_variable_for_generic_type(type_var)
            type_var.node = node

            if type_var.upper_bound
              type_var.compatible?(type_var.upper_bound, :lt)
            end

            if type_var.lower_bound
              type_var.compatible?(type_var.lower_bound, :gt)
            end
          end
        end
        yield(module_self_variable)

        # Since every single time we find the generic type the same instance
        # will be returned, the local_typing_context will still be associated.
        # This is the reason we need to build a new typing context cloning this
        # one while type materialization.
        Types::TypingContext.pop_context
      end
    end
  end
end
