require_relative '../spec_helper'


describe TypedRb::Languages::PolyFeatherweightRuby::Types::Polymorphism::Unification do
  it 'should be able to unify a simple constraint' do
    type_var = tyvariable('@a')
    integer = tyobject(Integer)
    type_var.compatible?(integer)

    unification = described_class.new(type_var.constraints)
    unification.run
    expect(type_var.bound).to eq(integer)
  end

  context 'with variable instance assignations' do
    it 'should be able to unify compatible types' do
      type_var = tyvariable('@a')
      integer = tyobject(Integer)
      numeric = tyobject(Numeric)
      # @a = Integer
      type_var.compatible?(integer, :gt)
      # @a = Numeric
      type_var.compatible?(numeric, :gt)

      unification = described_class.new(type_var.constraints)
      unification.run.bindings

      # @a = max(Integer, Numeric)
      expect(type_var.bound).to eq(numeric)
    end

    it 'should find the join of the types' do
      type_var = tyvariable('@a')
      integer = tyobject(Integer)
      string = tyobject(String)
      # @a = Integer
      type_var.compatible?(integer, :gt)
      # @a = String
      type_var.compatible?(string, :gt)

      unification = described_class.new(type_var.constraints)
      unification.run.bindings

      # @a = max(Integer, String) => join(Integer, Sring) => Object[Comparable,Kernel]
      expect(type_var.bound.with_ruby_type).to be_falsey
      expect(type_var.bound.ruby_type).to eq(Object)
      expect(type_var.bound.modules).to include(Comparable)
      expect(type_var.bound.modules).to include(Kernel)
    end
  end

  context 'with variable instance application' do
    it 'should be able to unify same type' do
      type_var = tyvariable('@a')
      integer = tyobject(Integer)
      # @a = Integer
      type_var.compatible?(integer, :gt)
      # f(a::Integer = @a)
      type_var.compatible?(integer, :lt)

      unification = described_class.new(type_var.constraints)
      unification.run.bindings

      # @a = min(Integer, Integer) if Integer <= Integer
      expect(type_var.bound).to eq(integer)
    end

    it 'should be able to unify matching types' do
      type_var = tyvariable('@a')
      integer = tyobject(Integer)
      numeric = tyobject(Numeric)
      # @a = Integer
      type_var.compatible?(integer, :gt)
      # f(a::Numeric = @a)
      type_var.compatible?(numeric, :lt)

      unification = described_class.new(type_var.constraints)
      unification.run.bindings

      # @a = min(Integer, Numeric) if Integer <= Numeric
      expect(type_var.bound).to eq(integer)
    end

    it 'should raise a unification exception for incompatible types' do
      type_var = tyvariable('@a')
      string = tyobject(String)
      numeric = tyobject(Numeric)
      # @a = String
      type_var.compatible?(string, :gt)
      # f(a::Numeric = @a)
      type_var.compatible?(numeric, :lt)

      unification = described_class.new(type_var.constraints)
      expect {
        # @a = min(String, Numeric) if String < Numeric => FAIL
        unification.run.bindings
      }.to raise_error TypedRb::Languages::PolyFeatherweightRuby::Types::UncomparableTypes
    end
  end
end
