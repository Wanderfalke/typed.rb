# -*- coding: utf-8 -*-
require_relative '../model'

module TypedRb
  module Model
    # variable
    class TmVar < Expr

      attr_accessor :val

      def initialize(val, node)
        super(node)
        @val = val.to_s
      end

      def to_s
        "#{GenSym.resolve(@val)}"
      end

      def rename(from_binding, to_binding)
        if @val == from_binding
          @val = to_binding
        end
        self
      end

      def check_type(context)
        type = context.get_type_for(@val)
        if type.nil?
          fail TypeCheckError, "Cannot find binding for var '#{@val}' in the context"
        end
        type
      end
    end
  end
end
