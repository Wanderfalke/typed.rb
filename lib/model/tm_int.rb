# -*- coding: utf-8 -*-
require_relative '../model'

module TypedRb
  module Model
    # integers
    class TmInt < Expr
      attr_accessor :val
      def initialize(node)
        super(node, Types::TyInteger.new(node))
        @val = node.children.first
      end
    end
  end
end
