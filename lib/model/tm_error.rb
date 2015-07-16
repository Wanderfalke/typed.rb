# -*- coding: utf-8 -*-
require_relative '../model'

module TypedRb
  module Model
    class TmError < Expr
      def initialize(node)
        super(node)
      end

      def check_type(_context)
        Types::TyError.new
      end
    end
  end
end
