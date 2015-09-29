require 'continuation'

class BasicObject
  ts '#initialize / -> unit'
  ts '#! / -> Boolean'
  ts '#!= / BasicObject -> Boolean'
  ts '#== / BasicObject -> Boolean'
  ts '#__id__ / -> Integer'
  ts '#__send__ / BasicObject -> BasicObject... -> BasicObject'
  ts '#equal? / BasicObject -> Boolean'
  ts '#instance_eval / String -> String -> Integer -> &(BasicObject -> unit) -> BasicObject'
  ts '#method_missing / Symbol -> BasicObject... -> BasicObject'
  ts '#singleton_method_added / Symbol -> unit'
  ts '#singleton_method_removed / Symbol -> unit'
  ts '#singleton_method_undefined / Symbol -> unit'
  ts '#ts / String -> unit'
  ts '#cast / BasicObject -> BasicObject -> BasicObject'
end

class Object
  ts '#to_s / -> String'
end

module Kernel
  ts '#send / BasicObject -> BasicObject... -> BasicObject'
  ts '#object_id / -> Integer'
  ts '#Array / Range -> Array[Integer]'
  ts '#Complex / BasicObject -> Integer -> Complex'
  ts '#Float / BasicObject -> Float'
  ts '#Hash / BasicObject -> Hash[BasicObject][BasicObject]'
  ts '#Integer / BasicObject -> Integer -> Integer'
  ts '#Rational / BasicObject -> Rational'
  ts '#String / BasicObject -> String'
  ts '#__callee__ / -> Symbol'
  ts '#__dir__ / -> String'
  ts '#__method__ / -> Symbol'
  ts '#` / String -> BasicObject'
  ts '#abort / String -> unit'
  ts '.abort / String -> unit'
  ts '#at_exit / &(-> unit) -> Proc'
  ts '#autoload / BasicObject -> String -> unit'
  ts '#autoload? / Symbol -> String'
  ts '#binding / -> Binding'
  ts '#block_given? / -> Boolean'
  ts '#callcc / &(Continuation -> BasicObject) -> BasicObject'
  ts '#caller / Integer -> Integer -> Array[String]'
  ts '#caller / Range -> Array[String]'
end

class Class
  ts '#initialize / -> Class'
  ts '#initialize / Class -> Class'
  ts '#allocate / BasicObject'
end

ts 'type Array[T]'
class Array
  ts '.[] / [T]... -> Array[T]'
  ts '#initialize / Integer -> Array[T]'
  ts '#initialize / Integer -> [T] -> Array[T]'
  ts '#& / Array[T] -> Array[T]'
  ts '#* / Integer -> Array[T]'
  ts '#+ / Array[T] -> Array[T]'
  ts '#- / Array[T] -> Array[T]'
  ts '#<< / [T] -> Array[T]'
  ts '#<=> / Array[T] -> Integer'
  ts '#== / Array[T] -> Array[T]'
  ts '#at / Integer -> [T]'
  ts '#[] / Object -> Object'
  ts '#[] / Integer -> Integer -> Array[T]'
  ts '#any? / &([T] -> Boolean) -> Boolean'
  ts '#assoc / Object -> Array[T]'
  ts '#bsearch / &([T] -> Boolean) -> [T]'
  ts '#clear / -> Array[T]'
  ts '#collect[E] / &([T] -> [E]) -> Array[E]'
  ts '#collect![E] / &([T] -> [E]) -> Array[E]'
  ts '#combination / Integer -> Array[Array[T]]'
  ts '#compact / -> Array[T]'
  ts '#compact! / -> Array[T]'
  ts '#concat / Array[T] -> Array[T]'
  ts '#count / &([T] -> Boolean) -> Integer'
  ts '#count / [T] -> Integer'
  ts '#cycle / &([T] -> unit) -> unit'
  ts '#cycle / Integer -> &([T] -> unit) -> unit'
  # diff no block vs block
  ts '#delete / [T] -> &(-> [T]) -> [T]'
  ts '#delete_at / Integer -> [T]'
  ts '#delete_if / &([T] -> Boolean) -> Array[T]'
  ts '#drop / Integer -> Array[T]'
  ts '#drop_while / &([T] -> Boolean) -> Array[T]'
  ts '#each / &([T] -> unit) -> Array[T]'
  ts '#each_index / &([Integer] -> unit) -> Array[T]'
  ts '#empty? / -> Boolean'
  ts '#eql? / Array[?] -> Boolean'
  ts '#fetch / Integer -> &(Integer ->[T]) -> [T]'
  ts '#fetch / Integer -> [T] -> [T]'
  # diff no block vs block
  ts '#fill / [T] -> Array[T]'
  ts '#fill / [T] -> Integer -> Array[T]'
  ts '#fill / [T] -> Integer -> Integer -> Array[T]'
  ts '#find_index / &([T] -> Boolean) -> Integer'
  ts '#find_index / [T] -> Integer'
  ts '#first / -> Array[T]'
  ts '#first / Integer-> Array[T]'
  ts '#flatten / -> Array[Object]'
  ts '#flatten / Integer -> Array[Object]'
  ts '#flatten! / -> Array[Object]'
  ts '#flatten! / Integer -> Array[Object]'
  ts '#frozen? / -> Boolean'
  ts '#hash / -> Integer'
  ts '#include? / [T] -> Boolean'
  # diff no block vs block
  ts '#index / &([T] -> Boolean) -> Integer'
  ts '#index / [T] -> Integer'
  ts '#initialize_copy / Array[T] -> Array[T]'
  ts '#insert / Integer -> [T] -> [T]... -> Array[T]'
  ts '#inspect / -> String'
  ts '#join / -> String'
  ts '#join / String -> String'
  ts '#keep_if / &([T] -> Boolean) -> Array[T]'
  ts '#last / -> [T]'
  ts '#last / Integer -> Array[T]'
  ts '#length / -> Integer'
  ts '#map[E] / &([T] -> [E]) -> Array[E]'
  ts '#map![E] / &([T] -> [E]) -> Array[E]'
  ts '#pack / String -> String'
  # diff no block vs block
  ts '#permutation / -> Array[Array[T]]'
  ts '#permutation / Integer -> Array[Array[T]]'
  ts '#pop / -> [T]'
  ts '#pop / Integer -> Array[T]'
  ts '#product / Array[T]... -> Array[Array[T]]'
  ts '#push / [T]... -> Array[T]'
  # ts '#rassoc / '
  ts '#reject / &([T] -> Boolean) -> Array[T]'
  ts '#reject! / &([T] -> Boolean) -> Array[T]'
  ts '#repeated_combination / Integer -> Array[Array[T]]'
  ts '#repeated_permutation / Integer -> Array[Array[T]]'
  ts '#replace / Array[T] -> Array[T]'
  ts '#reverse / -> Array[T]'
  ts '#reverse! / -> Array[T]'
  ts '#reverse_each / &([T] -> unit) -> Array[T]'
  ts '#rindex / &([T] -> Boolean) -> Integer'
  ts '#rindex / [T] -> Integer'
  ts '#rotate / -> Array[T]'
  ts '#rotate / Integer -> Array[T]'
  ts '#rotate! / -> Array[T]'
  ts '#rotate! / Integer -> Array[T]'
  ts '#sample / -> Array[T]'
  ts '#sample / Integer -> Array[T]'
  ts '#select / &([T] -> Boolean) -> Array[T]'
  ts '#select! / &([T] -> Boolean) -> Array[T]'
  ts '#shift / -> [T]'
  ts '#shift / Integer -> Array[T]'
  ts '#shuffle / -> Array[T]'
  ts '#shuffle! / -> Array[T]'
  ts '#size / -> Integer'
  ts '#slice / Object -> Object'
  ts '#slice / Integer -> Integer -> Array[T]'
  ts '#slice! / Object -> Object'
  ts '#slice! / Integer -> Integer -> Array[T]'
  ts '#sort / &([T] -> [T] -> Integer) -> Array[T]'
  ts '#sort! / &([T] -> [T] -> Integer) -> Array[T]'
  ts '#sort_by! / &([T] -> Object) -> Array[T]'
  ts '#take / Integer -> Array[T]'
  ts '#take_while / &([T] -> Boolean) -> Array[T]'
  ts '#to_a / -> Array[T]'
  ts '#to_ary / -> Array[T]'
  ts '#to_h / -> Hash[T][T]'
  ts '#to_s / -> String'
  # ts '#transpose'
  ts '#uniq / &([T] -> Object) -> Array[T]'
  ts '#uniq! / &([T] -> Object) -> Array[T]'
  ts '#unshift / [T]... -> Array[T]'
  ts '#values_at / Integer... -> Array[T]'
  ts '#zip / Array[T]... -> Array[Array[T]]'
  ts '#| / Array[T] -> Array[T]'
end

class Module
  ts '#include / Module... -> Class'
end

ts 'type Hash[S][T]'
class Hash
  ts '#initialize / [S]... -> Hash[S][T]'
#  ts '#map[E] / &(Pair[S][T] -> [E]) -> Array[E]'
end

ts 'type Range[T]'
class Range; end

class Integer
  ts '#+ / Integer -> Integer'
  def +(other)
    fail StandardError.new('Error invoking abstract method Integer#+')
  end

  # TODO
  # [:+, :-, :*, :/, :**, :~, :&, :|, :^, :[], :<<, :>>, :to_f, :size, :bit_length]
end

ts 'type Pair[S][T] super Array[Object]'
class Pair < Array
  ts '#first / -> [S]'

  ts '#second / -> [T]'
  def second
    cast(at(1), '[T]')
  end
end
