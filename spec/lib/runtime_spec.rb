require_relative '../spec_helper'

describe BasicObject do

  before :each do
    ::BasicObject::TypeRegistry.clear
  end

  it 'parses type signatures and store data into the type registry' do
    $TYPECHECK = true
    code = <<__END
    class A

      ts 'A#test / String -> unit'
      def test(msg)
        puts msg
      end

      ts 'A.class_method / Int -> Int'

      ts '#abbrev / String -> String'
      ts '.abbrev / String -> String'
    end

    ts 'B#other_test / Int -> unit'
    ts 'A#other_test / Int -> unit'
__END

    eval(code)

    expect(::BasicObject::TypeRegistry.registry['instance|A']['test']).to eq(['String', :unit])
    expect(::BasicObject::TypeRegistry.registry['class|A']['class_method']).to eq(['Int', 'Int'])
    expect(::BasicObject::TypeRegistry.registry['instance|B']['other_test']).to eq(['Int', :unit])
    expect(::BasicObject::TypeRegistry.registry['instance|A']['other_test']).to eq(['Int', :unit])
    expect(::BasicObject::TypeRegistry.registry['instance|A']['abbrev']).to eq(['String', 'String'])
    expect(::BasicObject::TypeRegistry.registry['class|A']['abbrev']).to eq(['String', 'String'])
  end

  it 'normalizes the parsed types with information about the defined classes' do
    $TYPECHECK = true
    code = <<__END
     class A
       ts '#inc / Integer -> Integer'
       def inc(i)
         i+= 1
         i
       end
     end

     class B
       ts '#consume_a / A -> Integer'
       def consume_a(a)
         0
       end

       ts '#consume_b / unit -> Boolean'
       def consume_b
         1
       end
     end
__END

    eval(code)

    ::BasicObject::TypeRegistry.normalize_types!

    expect(::BasicObject::TypeRegistry.registry[[:instance,A]]["inc"].to_s).to eq("(Integer -> Integer)")
    expect(::BasicObject::TypeRegistry.registry[[:instance,B]]["consume_a"].to_s).to eq("(A -> Integer)")
    expect(::BasicObject::TypeRegistry.registry[[:instance,B]]["consume_b"].to_s).to eq("(NilClass -> Boolean)")
  end

  it 'parses field type signatures and store the result in the registry' do
    $TYPECHECK = true
    code = <<__END
     class A
       ts 'A\#@a / Integer'
       attr_accessor :a

       ts '#inc / Integer -> Integer'
       def inc(i)
         @a = i+ 1
         @a
       end
     end
__END

    eval(code)


    expect(::BasicObject::TypeRegistry.registry['instance_variable|A']['@a']).to eq('Integer')
  end

  it 'normalizes types signatures for fields and store the result in the registry' do
    $TYPECHECK = true
    code = <<__END
     class A
       ts 'A\#@a / Integer'
       attr_accessor :a

       ts '#inc / Integer -> Integer'
       def inc(i)
         @a = i+ 1
         @a
       end
     end
__END

    eval(code)

    ::BasicObject::TypeRegistry.normalize_types!

    expect(::BasicObject::TypeRegistry.registry[[:instance_variable,A]]["@a"].to_s).to eq('Integer')
  end

  it 'parses type function with multiple arguments' do
    $TYPECHECK = true
    code = <<__END
     class A
       ts '#func / Integer -> Integer -> Integer -> Integer'
       def func(i,j,k)
         i + j + k
       end
     end
__END

    eval(code)

    ::BasicObject::TypeRegistry.normalize_types!

    expect(::BasicObject::TypeRegistry.registry[[:instance,A]]["func"].to_s).to eq('(Integer,Integer,Integer -> Integer)')
  end


  it 'parses type function with multiple arguments' do
    $TYPECHECK = true
    code = <<__END
     class A
       ts '#func / Integer -> (Integer -> Integer -> Integer) -> Integer'
       def func(i)
         yield i, i
       end
     end
__END

    eval(code)

    ::BasicObject::TypeRegistry.normalize_types!

    expect(::BasicObject::TypeRegistry.registry[[:instance,A]]["func"].to_s).to eq('(Integer,(Integer,Integer -> Integer) -> Integer)')
  end

  it 'parses type functions with no arguments' do
    $TYPECHECK = true
    code = <<__END
     class A
       ts '#func / -> Integer'
       def func(i)
         1
       end
     end
__END

    eval(code)

    ::BasicObject::TypeRegistry.normalize_types!

    expect(::BasicObject::TypeRegistry.registry[[:instance,A]]["func"].to_s).to eq('( -> Integer)')
  end

  it 'parses type functions with functions with no arguments as argument' do
    $TYPECHECK = true
    code = <<__END
     class A
       ts '#func / Integer -> ( -> Integer) -> Integer'
       def func(i, f)
         f[]
       end
     end
__END

    eval(code)

    ::BasicObject::TypeRegistry.normalize_types!

    expect(::BasicObject::TypeRegistry.registry[[:instance,A]]["func"].to_s).to eq('(Integer,( -> Integer) -> Integer)')
  end

  it 'parses generic types' do
    $TYPECHECK = true
    code = <<__END
     ts 'type Container[X<Numeric]'
     class Container

       ts '#push / [X<Numeric] -> unit'
       def push(value)
        @value = value
       end

       ts '#pop / -> [X<Numeric]'
       def pop
        @value
       end

     end
__END

    eval(code)
    ::BasicObject::TypeRegistry.normalize_types!
    expect(::BasicObject::TypeRegistry.generic_types_registry[Container].ruby_type).to eq(Container)
    expect(::BasicObject::TypeRegistry.generic_types_registry[Container].type_vars[0].variable).to eq('Container:X')
    expect(::BasicObject::TypeRegistry.generic_types_registry[Container].type_vars[0].upper_bound.ruby_type).to eq(Numeric)
    expect(::BasicObject::TypeRegistry.registry[[:instance,Container]]['push'].from[0].variable).to eq('Container:X')
    expect(::BasicObject::TypeRegistry.registry[[:instance,Container]]['push'].from[0].upper_bound.ruby_type).to eq(Numeric)
    expect(::BasicObject::TypeRegistry.registry[[:instance,Container]]['pop'].to.variable).to eq('Container:X')
    expect(::BasicObject::TypeRegistry.registry[[:instance,Container]]['pop'].to.upper_bound.ruby_type).to eq(Numeric)
  end

  it 'parses concrete generic types' do
    $TYPECHECK = true
    code = <<__END
     ts 'type Array[X]'
     class Array; end

     ts 'type Cnt1[X<Numeric]'
     class Cnt1

        ts '#f1 / Array[Integer] -> unit'
        def f1(a); end

        ts '#f2 / Array[X] -> unit'
        def f2(a); end

     end
__END

    eval(code)
    ::BasicObject::TypeRegistry.normalize_types!

    f1_type = ::BasicObject::TypeRegistry.registry[[:instance,Cnt1]]['f1']
    f2_type = ::BasicObject::TypeRegistry.registry[[:instance,Cnt1]]['f2']
    expect(f1_type.from.first).to be_instance_of(TypedRb::Types::TyGenericObject)
    expect(f1_type.from.first.type_vars.first.bound.ruby_type).to eq(Integer)
    expect(f1_type.from.first.type_vars.first.variable).to eq('Array:X')
    expect(f2_type.from.first).to be_instance_of(TypedRb::Types::TyGenericSingletonObject)
    expect(f2_type.from.first.type_vars.first.bound).to eq(nil)
    expect(f2_type.from.first.type_vars.first.variable).to eq('Cnt1:X')
  end

  it 'parses function types with variable rest args' do
    $TYPECHECK = true
    code = <<__END
     ts 'type Array[X]'
     class Array; end

     class Cnt2

        ts '#f1 / String -> Integer... -> unit'
        def f1(s, *i); end

     end
__END

    eval(code)
    ::BasicObject::TypeRegistry.normalize_types!

    f1_type = ::BasicObject::TypeRegistry.registry[[:instance,Cnt2]]['f1']
    expect(f1_type.from[1]).to be_instance_of(TypedRb::Types::TyGenericObject)
    expect(f1_type.from[1].type_vars.first.bound.ruby_type).to eq(Integer)
    expect(f1_type.from[1].type_vars.first.variable).to eq('Array:X')
  end

  it 'parses function types with block arguments' do
    $TYPECHECK = true
    code = <<__END
    class Cnt3
       ts '#wblock / Integer -> &(Integer -> Integer) -> Integer'
       def wblock(x)
         yield x
       end
    end
__END

    eval(code)
    ::BasicObject::TypeRegistry.normalize_types!

    wblock_type = ::BasicObject::TypeRegistry.registry[[:instance,Cnt3]]['wblock']
    expect(wblock_type.block_type.from.size).to eq(1)
    expect(wblock_type.block_type.from.first.ruby_type).to eq(Integer)
    expect(wblock_type.block_type.to.ruby_type).to eq(Integer)
  end

  describe '.find' do

    it 'finds registered function types' do
      $TYPECHECK = true
      code = <<__END
     ts 'type Container[X<Numeric]'
     class Container

       ts '#push / [X<Numeric] -> unit'
       def push(value)
        @value = value
       end

       ts '#pop / -> [X<Numeric]'
       def pop
        @value
       end

     end
__END

      eval(code)
      ::BasicObject::TypeRegistry.normalize_types!


      function_type = ::BasicObject::TypeRegistry.find(:instance, Container, :push)
      expect(function_type).to be_is_a(TypedRb::Types::TyFunction)
      expect(function_type.from.size).to eq(1)
      type_var = function_type.from.first
      expect(type_var).to be_is_a(TypedRb::Types::Polymorphism::TypeVariable)
      expect(type_var.variable).to eq('Container:X')
      expect(type_var.upper_bound.ruby_type).to eq(Numeric)
      expect(::BasicObject::TypeRegistry.generic_types_registry[Container].type_vars[0].variable).to eq(type_var.variable)
      #expect(::BasicObject::TypeRegistry.generic_types_registry[Container].type_vars[0]).to eq(type_var)
    end
  end
end
