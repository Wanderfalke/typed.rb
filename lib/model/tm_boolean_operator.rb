require_relative '../model'

module TypedRb
  module Model
    # abstraction
    class TmBooleanOperator < Expr
      attr_accessor :operator, :lhs, :rhs

      def initialize(operator, lhs, rhs, node)
        super(node)
        @lhs = lhs
        @rhs = rhs
        @operator = operator
      end

      def check_type(context)
        lhs_type = @lhs.check_type(context)
        rhs_type = @rhs.check_type(context)
        if lhs_type.is_a?(Types::Polymorphism::TypeVariable) || rhs_type.is_a?(Types::Polymorphism::TypeVariable)
          var = Types::TypingContext.local_type_variable
          var.compatible?(lhs_type, :gt)
          var.compatible?(rhs_type, :gt)
          var
        else
          type = [lhs_type, rhs_type].max rescue Types::TyObject.new(Object, node)
          type.node = node
          type
        end
      end
    end
  end
end
