# -*- coding: utf-8 -*-
require_relative '../model'

module TypedRb
  module Model
    # floats
    class TmSymbol < Expr
      attr_accessor :val
      def initialize(node)
        super(node, Types::TySymbol.new(node))
        @val = node.children.first
      end
    end
  end
end
