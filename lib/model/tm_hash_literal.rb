require_relative '../model'

module TypedRb
  module Model
    class TmHashLiteral < Expr
      attr_reader :pairs
      def initialize(pairs, node)
        super(node)
        @pairs = pairs
      end

      def rename(from_binding, to_binding)
        @pairs = pairs.map do |(key, value)|
          key = key.rename(from_binding, to_binding)
          value = value.rename(from_binding, to_binding)
          [key, value]
        end
        self
      end

      def check_type(context)
        pair_types = pairs.map { |key, element|  [key.check_type(context), element.check_type(context)] }
        max_key_type = pair_types.map(&:first).max rescue Types::TyObject.new(Object, node)
        max_value_type = pair_types.map(&:last).max rescue Types::TyObject.new(Object, node)
        type_var_key = Types::Polymorphism::TypeVariable.new('Hash:T',
                                                             :node => node,
                                                             :gen_name => false,
                                                             :upper_bound => max_key_type,
                                                             :lower_bound => max_key_type)
        type_var_key.bind(max_key_type)
        type_var_value = Types::Polymorphism::TypeVariable.new('Hash:U',
                                                               :node => node,
                                                               :gen_name => false,
                                                               :upper_bound => max_value_type,
                                                               :lower_bound => max_value_type)
        type_var_value.bind(max_value_type)
        Types::TyGenericObject.new(Hash, [type_var_key, type_var_value], node)
      end
    end
  end
end
