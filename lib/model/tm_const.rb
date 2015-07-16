require_relative '../model'

module TypedRb
  module Model
    # A constant expression
    class TmConst < Expr
      attr_reader :val

      def initialize(val, node)
        super(node)
        @val = val
      end

      def rename(_from_binding, _to_binding)
        self
      end

      def check_type(_context)
        value = Object.const_get(@val)
        if value.instance_of?(Class)
          Types::Type.parse_singleton_object_type(value.name)
        else
          Types::Type.parse_object_type(value.name)
        end
      end
    end
  end
end
