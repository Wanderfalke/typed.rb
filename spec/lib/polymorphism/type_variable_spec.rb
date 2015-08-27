require_relative '../../spec_helper'

describe TypedRb::Types::Polymorphism::TypeVariable do
  it 'should record constraints' do
    type = tyobject(Integer)
    type_var = TypedRb::Types::TypingContext.type_variable_for(:test, '@a', [Object])
    type_var.compatible?(type)
    expect(type_var.constraints).to eq([[type_var, :lt, type]])

    type2 = tyobject(String)
    type_var.compatible?(type2, :gt)
    expect(type_var.constraints).to eq([[type_var, :lt, type], [type_var, :gt, type2]])
  end
end
