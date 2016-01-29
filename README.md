#Typed.rb [![Build Status](https://circleci.com/gh/antoniogarrote/typed.rb.png?circle-token=:circle-token)](https://circleci.com/gh/antoniogarrote/typed.rb/tree/master) [![Coverage Status](https://coveralls.io/repos/github/antoniogarrote/typed.rb/badge.svg?branch=master)](https://coveralls.io/github/antoniogarrote/typed.rb?branch=master)

Gradual type checker for Ruby.

Example from `spec/lib/examples/monoid.rb`:

```ruby
require 'typed/runtime'

ts 'type Monoid[T]'
module Monoid

  ts '#mappend / [T] -> [T] -> [T]'
  abstract(:mappend)

  ts '#mempty / -> [T]'
  abstract(:mempty)

end


ts 'type Sum[Integer] super Monoid[T]'
class Sum

  include Monoid

  def mappend(a,b)
    a + b
  end

  def mempty
    0
  end

end


ts '#sum / Array[Integer] -> Integer'
def sum(xs)
  monoid = Sum.new
  zero = monoid.mempty
  xs.reduce(zero) { |a,b| monoid.mappend(a,b) }
end


ts '#moncat[T] / Array[T] -> Monoid[T] -> [T]'
def moncat(xs, m)
  zero = m.mempty
  xs.reduce(zero) { |a,b| m.mappend(a,b) }
end

->() {
  moncat([1,2,3], Sum.new)
}
```


## Introduction

Typed.rb is an attempt to build a gradual type checker for the Ruby programming language.

Typed.rb provides a mechanism to add type annotations to Ruby program's classes, modules and methods, and makes it possible to type-check the annotated code statically.
Types annotations has no impact on performance during the execution of the program. Typed ruby code is valid regular ruby code.
Typed.rb leverages gradual typing for Ruby, this means that typed and untyped code can be freely mixed.

In it's current implementation Typed.rb includes the following components:

- A type signature language to annotate classes, modules and methods.
- A small run-time library that introduces a few extensions to ruby core types, like the type annotations method or the application of type parameters, it introduces some new types like Boolean and Pair and the notion of abstract methods.
- Type annotations for the Ruby Standard Library.
- A gradual type checker that can be executed statically to check the provided annotations.

Typed.rb tries to typecheck most of the static subset of Ruby with as few type annotations as possible, however, due to the highly dynamic nature of Ruby some compromises need to be made and the whole dynamic set of the language, say, dynamically evaluated methods and classes cannot be type-checked.

Typed.rb is still an ongoing effort and should be considered pre-alpha.


## Type system

Typed.rb type system's matches Ruby type system with a few exceptions:

- A ```unit``` matching the runtime ```NilClass``` class has been added to the type signature language. It is inhabited by a single instalce ```nil``` and it's a subclass of all other types. ```unit``` must always be used in type signatures
- A ```dynamic``` type that by-passes type checking will be generated byt the type-checker when no typing information is available for a given method or type. Type checking untyped code will produce the ```dynamic``` type as a result. ```dynamic``` must never diractely used in a type annotation.
- A ```Boolean ``` type has been added inhabited by only two values ```true``` and ```false``` and matching both run-time classes ```TrueClass``` and ```FalseClass``` has been added to the type signature language. ```Boolean``` must always be used in type signatures
- A polymorphic ```Pair[T][U]``` extending ```Array``` type has been added to the type signature language and to the runtime. Function and blocks receiving or returning arrays of two elements can be annotated as using the ```Pair``` type
- A ```Showable``` type with no methods has been added as mixin into the ```String``` and ```Symbol``` class and can be used to annotate methods receiving an instance of any of these two classes


## Type annotations

To introduce a new type annotation, the ```BasicObject#ts``` method can be used. They can appear in any part of the source code without taking in cosideration the location of the method being annotated, however as a rule, we try to add the type annotation before the definition of the method being annotated.
The method receives a string with the type signature and returns unit. At run-time the method is a noop.

A type signature for a method is composed of the following parts:

```
Type?(#/.)method[T]* / ArgumentType? (-> ArgumentType)* (-> &BlockType)? -> ReturnType
```

For example, the type signature of the ```#ts``` method itself is ```BasicObject#ts / String -> unit```.

The main components of a type signature are:

- ```Type``` (optional), type the method belongs to. If the type part of the signature is ommitted, the current wrapping class or module is considered to be the target of the method
- ```(#/.)``` instance/class indicator. Instance level methods are prefixed with ```#```, class level methods are prefixed with ```.```
- ```method``` message this method is handling
- ```[T]*``` method type variables for polymorphic methods
- ```/``` signature separator, a fixed character ```/``` separating the method information from the actual type arguments and return type information
- ```ArgumentType? (-> ArgumentType)* -> ReturnType``` an arrow (```->```) separated list of types representing the types of the input arguments and the output type of the method

If the method has no input arguments, the only return type can be expressed with a type with an initial ```->```. For example, a method with no arguments and returning ```nil``` can be expressed as ```-> unit```.
Higher order methods accepting procs or lambdas as inputs can be expressed between parentheses ```(ArgumentType? (-> ArgumentType)* -> ReturnType)```. Methods yielding a block can be expressed with final input argument of function type prefixed with a ```&```.
For example, the ```Enumerable#map``` method from the Ruby Standard Library accepting a block and parametric on the return value of that block has the following type annotation:

```
ts '#map[E] / &([T] -> [E]) -> Array[E]'
```

Methods accepting a variable number of arguments can be expressed using a suffix ellipsis ```...``` after the type of the vararg type. For instance, a method adding any number of integers could be expressed with the following type annotation:

```
ts '#my_sum / Integer... -> Integer'
```

More than one type annotation can be provided for the same method, but the arity of the annotations must be unique. Optional blocks are taking into consideration to compute the arity of the annotation.

In order to annotate classes and modules, the ```BasicObject#ts``` method is also used. Again, the type annotation can appear in any location of the source code but by convention we try to locate them before the implementation of the type if it is available.

Type annotations are only required for polymorphic types.

The type signature for a class/module has the following components:

```
type TypeName[T]? (super BaseType[U]*)?
```

- ```type``` prefix for all type annotations
- ```TypeName``` name of the class/module
- ```[T]*``` type variables for the polymorphic type
- ```(super BaseType[U]*)?``` base polymorphic class/module for the type

If one class extends generic classes or includes/extends generic modules and not super annotation is provided but a generic annotation is provided, the type checker will try to use the already existing annotation matching the type variable of the super type with the type variables of the base type.
More than one type annotation can be provided for polymorphic type to declare multiple types in the super clause. For instance, given the following types

```ruby
ts 'type Ca[T]'
class Ca
 # ...
end

ts 'type Ma[T]'
module Ma
 # ...
end

class B < Ca
  include Ma
end
```

The following declarations are equivalent:

```ruby
# Annotation a)
ts 'type B[T] super Ca[T], Ma[T]'

# Annotation b)
ts 'type B[T] super Ca[T]'
ts 'type B[T] super Ma[T]'
```

In the current implementation, ```super``` clauses in the type annotation must be used for super classes but also for modules extended in class singleton object:

```ruby
module M
  ts 'type M::InstanceMethods[T]'
  module InstanceMethods
    # ...
  end

  ts 'type M::ClassMethods[T]'
  module ClassMethods
    # ...
  end
end


# super must be used for both
ts 'type W[T] super M::InstanceMethods[T]'
ts 'type W[T] super M::ClassMethods[T]'
class W
  include M::InstanceMethods
  extend M::ClassMethods
end
```
## Polymorphism

Typed.rb supports annotations for polymorphic types and methods. Type variables are introduced using square brackets and a capital letter (e.g ```[T]```).
When creating an instance of a polymorphic type in your code, information about the specialization of the type variables must be provided. The Typed.rb runtime defines a version of the ```#call`` method for the ```Class``` class as a noop that can be used to pass the value of the type variables.
For example, to declare an ```Array``` of ```Integers``` the following code can be used:

```ruby
xs = Array.(Integer).new
```
Instead of a class, a string with the description of the type variables using the same syntax as the one used in the type annotations can be used.
The previous definition could be expressed in an equivalent way using the following snippet:

```ruby
xs = Array.('Integer').new
```

Using a string is the only option when dealing with type vars as in the following declaration:

```ruby
ts 'type Wrapper[T]'
class Wrapper

  ts '#zero / -> Array[T]'
  def zero
   Array.('[T]').new
  end

end
```

If no value for the type variables of the polymorphic type are given, the type checker will assume that ```Object``` is used.

When initiating objects using type literals, like arrays or hashes, the type checker will try to infer the type variables using the max type for the provided values in the literal:

```ruby
[1, 2, 3]    # Array[Integer]
[1, :2, '3'] # Array[Object]
```

Type boundaries can be provided for the type variables using the ```?```, ```<``` and ```>``` symbols, where ```?``` is used as type wildcard, for instance: ```[? < Integer]```, ```[? > String]```. ```[?]```.
For example, the following snippet shows how to use type boundaries in a method:

```ruby
ts '#test_bound1 / Array[? < Integer] -> unit'
def test_bound1(gc); end

# This application will type-check correctly
arg1 = Array.(Integer).new
test_bound1(arg1)

# This application will fail type-checking
arg2 = Array.(Numeric).new
test_bound1(arg2)
```

## Run-time additions and considerations

In order to use the type checker, the runtime portion of the library must be included in the code to be checked through the ```typed/runtime``` script.
This library includes the discussed extensions to the standard library that allow to declare type annotations.

```ruby
include 'typed/runtime'

# ts available now
ts '#foo / -> unit'
```
As we have discussed the modifications introduced by typed.rb define noops with no performance impact on the execution of Ruby code.

Typed.rb defines an ```abstract``` method that can introduce methods in a module/class intended to be implemented by subclasses.
Modules with only abstract methods can form the basis for an interface declaration, however, in the current implementation the type checker doesn't check that the subclass including the abstract module provides an implementation for all the abstract methods.
If an abstract method is invoked at run-time, an exception will be thrown.

```ruby
ts 'type Monoid[T]'
module Monoid

  ts '#mappend / [T] -> [T] -> [T]'
  abstract(:mappend)

  ts '#mempty / -> [T]'
  abstract(:mempty)

end
```

In order to perform the type checking, typed.rb will load your program in memory to collect information from the Ruby run-time about the types defined in the scripts to be type-checked.
This means that code performing side effects at the top level of a script will be executed during type-checking.
To protect these portions of the code, the global ```$TYPECHECK``` boolean variable can be used to protect these sections of the code:


```ruby
# the following method application will not be evaluated
# when performing type-checking.

my_app.run! unless $TYPECHECK
```

To instruct the type checker to not check a method in the code the ```BasicObject#ts_ignore``` method can be used. When inserted before a method definition, the type-checker will not evaluate the body of that method.
Even if the ```ts_ignore``` annotation is used, a proper type annotation can also be provided so client code will be type checked using the provided annotation when invoking the ignored method:

```ruby

# Foo will still have type '-> Integer'
ts '#foo / -> Integer'
ts_ignore
def foo
  3 # The body of foo will not be type-checked
end
```

Sometimes it is useful to cast an expression into a type. This can be accomplished using the ```BasicObject#cast``` method.
```cast``` accepts two parameters, an expression, and a type expression. It has not effect at run-time, just returning the result of the expression in the first argument, but during type-checking will provide the type defined in the second argument as the resulting type for the expression in the first argument:

```ruby
a = cast(send(:dynamic_invocation),'Integer') # send(:dynamic_invocation) will have type Integer
```

## Type inference and minimal typing

Typed.rb will try to perform automatic type inference for the following language constructs and don't need to be annotated:

- global variables
- instance variables
- local variables
- constants
- lambda functions

To know more about the type inferance mechanism, check the implementation of the unification algorithm used by the type checker in ```lib/typed/types/polymorphism/unification.rb```.

Class and modules only need to be annotated if they are defined as polymorphic. All methods must be annotated.

## Running the type-checker

To execute the type checker, the ```bin/typed.rb``` script can be used. The script accepts a list of options and path to the entry-point of the source code to be type-checked. Currently the only option available is ```--missing-type``` that will force the type-checker to produce a warning every single time a default dynamic type is introduced due to lack of typing information.

The script will produce some error report output and return an appropriate exit value according to the result of the the check.

## Bibliography

- Types and programming languages, Pierce, MIT Press
- [Local Type Inference,Pierce, Turner](http://www.cis.upenn.edu/~bcpierce/papers/lti-toplas.pdf)
- [Dynamic Inference of Static Types for Ruby, Jong-hoon (David) An](http://drum.lib.umd.edu/bitstream/handle/1903/10946/An_umd_0117N_11611.pdf;jsessionid=E6E82129BA5C84B19A98303566F8C4DA?sequence=1)
- [A Practical Optional Type System for Clojure, Ambrose Bonnaire-Sergeant](https://cloud.github.com/downloads/frenchy64/papers/ambrose-honours.pdf)
- [Designand Evaluation of Gradual Typing for Python, Vitousek, Kent, Siek et alt.](http://wphomes.soic.indiana.edu/jsiek/files/2014/08/retic-python-v3.pdf)
- [On Understanding Types, Data Abstraction, and Polymorphism, Cardelli, Wegner](http://lucacardelli.name/papers/onunderstanding.a4.pdf)
- [An Imperative Object Calculus, Abadi, Cardelli](http://agp.hx0.ru/oop/PrimObjImp.pdf)

## License

Copyright 2016 Antonio Garrote

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
