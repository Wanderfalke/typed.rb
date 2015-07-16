# -*- coding: utf-8 -*-
require_relative '../model'

module TypedRb
  module Model
    class TmIfElse < Expr
      def initialize(node, condition_expr, then_expr, else_expr)
        super(node, nil)
        @condition_expr = condition_expr
        @then_expr = then_expr
        @else_expr = else_expr
      end

      def rename(from_binding, to_binding)
        @condition_expr.rename(from_binding, to_binding)
        @then_expr.rename(from_binding, to_binding)
        @else_expr.rename(from_binding, to_binding)
        self
      end

      def check_type(context)
        if @condition_expr.check_type(context).compatible?(Types::TyObject.new(BasicObject), :lt)
          then_expr_type = @then_expr.check_type(context)
          else_expr_type = @else_expr.check_type(context)
          if then_expr_type.compatible?(else_expr_type) && else_expr_type.compatible?(then_expr_type)
            if then_expr_type.is_a?(Types::Polymorphism::TypeVariable)
              then_expr_type
            elsif else_expr_type.is_a?(Types::Polymorphism::TypeVariable)
              else_expr_type
            elsif Types::TyError.is?(then_expr_type)
              else_expr_type
            elsif then_expr_type.is_a?(Types::TyDynamic) || then_expr_type.is_a?(Types::TyDynamicFunction)
              else_expr_type
            else
              then_expr_type
            end
          else
            fail TypeCheckError, 'Arms of conditional have different types'
          end
        else
          fail TypeCheckError, 'Expected Bool type in if conditional expression'
        end
      end
    end
  end
end
