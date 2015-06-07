require_relative '../../../../spec_helper'

describe TypedRb::Languages::FeatherweightRuby::Types::Type do

  before :each do
    ::BasicObject::TypeRegistry.registry.clear
  end

  let(:typed_code) do
    $TYPECHECK = true
    eval(code, TOPLEVEL_BINDING)
    ::BasicObject::TypeRegistry.normalize_types!
    code
  end

  let(:ast) do
    TypedRb::Languages::FeatherweightRuby::Model::GenSym.reset
    parser = TypedRb::Languages::FeatherweightRuby::Parser.new
    parser.parse(typed_code)
  end

  context 'with valid exact type' do
    let(:code) do
      text =<<__CODE
        ts '#test / Integer -> Integer'
        def test(x)
          x
        end
__CODE
      text
    end

    it 'should not raise a type error' do
      expect {
        ast.check_type(TypedRb::Languages::FeatherweightRuby::Types::TypingContext.top_level)
      }.to_not raise_error
    end
  end

  context 'with  a super-type class' do
    let(:code) do
      text =<<__CODE
        ts '#test / Integer -> Numeric'
        def test(x)
          x
        end
__CODE
      text
    end

    it 'should not raise a type error' do
      expect {
        ast.check_type(TypedRb::Languages::FeatherweightRuby::Types::TypingContext.top_level)
      }.to_not raise_error
    end
  end

  context 'with  a sub-type class' do
    let(:code) do
      text =<<__CODE
        ts '#test / Numeric -> Integer'
        def test(x)
          x
        end
__CODE
      text
    end

    it 'should not raise a type error' do
      expect {
        ast.check_type(TypedRb::Languages::FeatherweightRuby::Types::TypingContext.top_level)
      }.to raise_error(TypedRb::Languages::FeatherweightRuby::Model::TypeError)
    end
  end
end