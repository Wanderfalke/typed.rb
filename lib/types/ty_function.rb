module TypedRb
  module Types
    class TyFunction < Type
      attr_accessor :from, :to, :parameters_info, :block_type, :arity
      attr_writer :name

      def initialize(from, to, parameters_info = nil, node = nil)
        super(node)
        @from            = from.is_a?(Array) ? from : [from]
        @to              = to
        @parameters_info = parameters_info
        if @parameters_info.nil?
          @parameters_info = @from.map { |type| [:req, type] }
        end
        @arity           = parse_function_arity
        @block_type      = nil
      end

      def with_block_type(type)
        @block_type = type
        self
      end

      def arg_compatible?(num_args)
        arity == Float::INFINITY ? true : arity == num_args
      end

      def generic?
        false
      end

      def dynamic?
        false
      end

      def to_s
        args = @from.map(&:to_s).join(', ')
        args = "#{args}, &#{block_type}" if block_type
        "(#{args} -> #{@to})"
      end

      def name
        @name || 'lambda'
      end

      def check_args_application(actual_arguments, context)
        parameters_info.each_with_index do |(require_info, arg_name), index|
          actual_argument = actual_arguments[index]
          from_type = from[index]
          if actual_argument.nil? && require_info != :opt
            error_msg = "Type error checking function '#{name}': Missing mandatory argument #{arg_name} in #{receiver_type}##{message}"
            fail TypeCheckError.new(error_msg, node)
          else
            unless actual_argument.nil? # opt if this is nil
              actual_argument_type = actual_argument.check_type(context)
              unless actual_argument_type.compatible?(from_type, :lt)
                error_message = "Type error checking function '#{name}': #{error_message} #{from_type} expected, #{argument_type} found"
                fail TypeCheckError.new(error_message, node)
              end
            end
          end
        end
        self
      end

      # (S1 -> S2) < (T1 -> T2) => T1 < S1 && S2 < T2
      # Contravariant in the input, covariant in the output
      def compatible?(other_type, relation = :lt)
        if other_type.is_a?(TyGenericFunction)
          other_type.compatible?(self, relation == :lt ? :gt : :lt)
        elsif other_type.is_a?(TyFunction)
          from.each_with_index do |arg, i|
            other_arg = other_type.from[i]
            return false unless arg.compatible?(other_arg, :gt)
          end
          return false unless to.compatible?(other_type.to, :lt)
        else
          fail TypeCheckError.new("Type error checking function '#{name}': Comparing function type with no function type")
        end
        true
      end

      def apply_bindings(bindings_map)
        from.each_with_index do |from_type, i|
          if from_type.is_a?(Polymorphism::TypeVariable)
            from_type.apply_bindings(bindings_map)
            from[i] = from_type.bound if from_type.bound
          elsif from_type.is_a?(TyGenericSingletonObject) || from_type.is_a?(TyGenericObject)
            from_type.apply_bindings(bindings_map)
          end
        end

        if to.is_a?(Polymorphism::TypeVariable)
          @to = to.apply_bindings(bindings_map)
          @to = to.bound if to.bound
        elsif to.is_a?(TyGenericSingletonObject) || to.is_a?(TyGenericObject)
          @to = to.apply_bindings(bindings_map)
        end

        block_type.apply_bindings(bindings_map) if block_type && block_type.generic?
        self
      end

      protected

      def parse_function_arity
        return Float::INFINITY if parameters_info.detect { |arg| arg.is_a?(Hash) && arg[:kind] == :rest }
        parameters_info.reject { |arg| arg.is_a?(Hash) && arg[:kind] == :block_arg }.count
      end
    end
  end
end
