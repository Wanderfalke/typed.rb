require_relative 'ty_object'
require_relative 'polymorphism/generic_comparisons'

module TypedRb
  module Types
    class TyGenericObject < TyObject

      include Polymorphism::GenericComparisons

      attr_reader :type_vars

      def initialize(ruby_type, type_vars, node = nil)
        super(ruby_type, node)
        @type_vars = type_vars
      end

      # This object has concrete type parameters
      # The generic Function we retrieve from the registry might be generic
      # If it is generic we apply the bound parameters and we obtain a concrete function type
      def find_function_type(message)
        generic_function = false # by default all variables will be bound to a concrete type
        function_klass_type, function_type = find_function_type_in_hierarchy(:instance, message)
        from_args = function_type.from.map do |arg|
          if arg.is_a?(Polymorphism::TypeVariable)
            matching_var = type_vars.detect { |type_var|  type_var.variable == arg.variable }
            if matching_var && matching_var.lower_bound
              matching_var.lower_bound || TyUnboundType.new(matching_var.variable, :lower_bound, node)
            else
              # Type variables and generic methods => function will still be generic
              generic_function = true
              arg
            end
          elsif arg.is_a?(TyGenericSingletonObject)
            arg.materialize_with_type_vars(type_vars, :lower_bound).as_object_type
          else
            arg
          end
        end

        to_arg = if function_type.to.is_a?(Polymorphism::TypeVariable)
                   matching_var = type_vars.detect{ |type_var| type_var.variable == function_type.to.variable }
                   if matching_var && matching_var.bound
                     matching_var.upper_bound ||  TyUnboundType.new(matching_var.variable, :upper_bound)
                   else
                     generic_function = true
                     function_type.to
                   end
                 elsif function_type.to.is_a?(TyGenericSingletonObject)
                   function_type.to.materialize_with_type_vars(type_vars, :upper_bound).as_object_type
                 else
                   function_type.to
                 end

        if generic_function
          materialised_function = TyGenericFunction.new(from_args, to_arg, function_type.parameters_info, node)
          materialised_function.local_typing_context = function_type.local_typing_context
        else
          materialised_function = TyFunction.new(from_args, to_arg, function_type.parameters_info, node)
        end

        materialised_function.with_block_type(function_type.block_type)
        [function_klass_type, materialised_function]
      end

      def generic?
        true
      end

      def to_s
        base_string = super
        var_types_strings = @type_vars.map do |var_type|
          "[#{var_type.bound || var_type.variable}]"
        end
        "#{base_string}#{var_types_strings.join}"
      end
    end
  end
end
