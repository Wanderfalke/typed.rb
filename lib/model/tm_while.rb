# -*- coding: utf-8 -*-
require_relative '../model'

module TypedRb
  module Model
    class TmWhile < Expr
      attr_reader :condition_expr, :body_expr
      def initialize(condition_expr, body_expr, node)
        super(node)
        @condition_expr = condition_expr
        @body_expr = body_expr
      end

      def check_type(context)
        condition_expr.check_type(context).compatible?(Types::TyObject.new(BasicObject, node), :lt)
        return Types::TyUnit.new(node) unless body_expr
        body_expr.check_type(context)
      end
    end
  end
end
