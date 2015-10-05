# -*- coding: utf-8 -*-
require_relative '../model'

module TypedRb
  module Model
    class TmDefined < Expr
      attr_reader :expression
      def initialize(expression, node)
        super(node)
        @expression = expression
      end

      def rename(from_binding, to_binding)
        @expression = expression.rename(from_binding, to_binding)
      end

      def check_type(context)
        expression.check_type(context)
        Types::TyString.new(node)
      end
    end
  end
end
