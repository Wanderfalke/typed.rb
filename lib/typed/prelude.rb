require 'continuation'

module Showable; end

class Symbol
  include Showable
end

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
  ts '#abstract / Symbol -> Symbol'
end

class Object
  ts '#!~ / Object -> Boolean'
  ts '#<=> / Object -> Integer'
  ts '#=== / Object -> Boolean'
  ts '#=~ / Object -> unit'
  ts '#class / -> Class'
  ts '#clone / -> Object'
  # ts '#define_singleton_method / '
  ts '#display / -> unit'
  ts '#display / IO -> unit'
  ts '#dup / -> Object'
  # diff no block vs block
  ts '#enum_for / -> Enumerator[Object]'
  ts '#enum_for / Symbol -> Enumerator[Object]'
  ts '#enum_for / Symbol -> Object... -> Enumerator[Object]'
  ts '#eql? / Object -> Boolean'
  ts '#extend / Module -> Object'
  ts '#freeze / -> Object'
  ts '#frozen? / -> Boolean'
  ts '#hash / -> Integer'
  ts '#inspect / -> String'
  ts '#instance_of? / Class -> Boolean'
  ts '#instance_variable_defined? / Showable -> Boolean'
  ts '#instance_variable_get / Showable -> Boolean'
  ts '#instance_variable_set / Showable -> Object -> Boolean'
  ts '#instance_variables / -> Array[Symbol]'
  ts '#is_a? / Class -> Boolean'
  ts '#itself / -> Object'
  ts '#kind_of? / Class -> Boolean'
  ts '#method / Symbol -> Method'
  ts '#methods / -> Array[Symbol]'
  ts '#methods / Boolean -> Array[Symbol]'
  ts '#nil? / -> Boolean'
  ts '#object_id / -> Integer'
  ts '#private_methods / -> Array[Symbol]'
  ts '#private_methods / Boolean -> Array[Symbol]'
  ts '#protected_methods / -> Array[Symbol]'
  ts '#protected_methods / Boolean -> Array[Symbol]'
  ts '#public_method / Symbol -> Method'
  ts '#public_methods / -> Array[Symbol]'
  ts '#public_methods / Boolean -> Array[Symbol]'
  ts '#public_send / Showable -> Object... -> Object'
  ts '#remove_instance_variable / Symbol -> Object'
  ts '#respond_to? / Showable -> Boolean'
  ts '#respond_to? / Showable -> Boolean -> Boolean'
  ts '#respond_to_missing? / Showable -> Boolean -> Boolean'
  ts '#send / Showable -> Object... -> Object'
  ts '#singleton_class / -> Class'
  ts '#singleton_method / Symbol -> Object'
  ts '#singleton_methods / Boolean -> Array[Method]'
  ts '#taint / -> Object'
  ts '#tainted? / -> Boolean'
  ts '#tap / &(Object -> unit) -> Object'
  # diff no block vs block
  ts '#to_enum / -> Enumerator[Object]'
  ts '#to_enum / Symbol -> Enumerator[Object]'
  ts '#to_enum / Symbol -> Object... -> Enumerator[Object]'
  ts '#to_s / -> String'
  ts '#trust / -> Object'
  ts '#untaint / -> Object'
  ts '#untrust / -> Object'
  ts '#untrusted? / -> Boolean'
end

module Kernel
  ts '#Array[E] / Range[E] -> Array[E]'
  ts '#Complex / Object -> Complex'
  ts '#Complex / Integer -> Integer -> Complex'
  ts '#Float / Object -> Float'
  ts '#Hash / Object -> Float'
  ts '#Integer / Object -> Integer'
  ts '#Integer / Object -> Integer -> Integer'
  ts '#Rational / Numeric -> Rational'
  ts '#Rational / Numeric -> Numeric -> Rational'
  ts '#String / Object -> String'
  ts '#__callee__ / -> Symbol'
  ts '#__dir__ / -> String'
  ts '#__method__ / -> Symbol'
  ts '#` / String -> Object'
  ts '#abort / -> unit'
  ts '#abort / String -> unit'
  ts '.abort / -> unit'
  ts '.abort / String -> unit'
  ts '#at_exit / &(-> unit) -> Proc'
  ts '#autoload / Showable -> String -> unit'
  ts '#autoload? / Showable -> String'
  ts '#binding / -> Binding'
  ts '#block_given? / -> Boolean'
  ts '#callcc / &(Continuation -> Object) -> Object'
  ts '#caller / Range -> Array[String]'
  ts '#caller / Integer -> Integer -> Array[String]'
  ts '#caller_locations / Range[Integer] -> Array[String]'
  ts '#caller_locations / Integer -> Integer -> Array[String]'
  # ts '#catch / -> unit'
  # ts '#chomp / String -> String'
  # ts '#chop / String -> String'
  ts '#eval / String -> Object'
  ts '#eval / String -> Binding -> Object'
  ts '#eval / String -> Binding -> String -> Object'
  ts '#eval / String -> Binding -> String -> Integer -> Object'
  ts '#exec / Object... -> String'
  ts '#exit / -> unit'
  ts '#exit / Boolean -> unit'
  ts '#exit! / -> unit'
  ts '#exit! / Boolean -> unit'
  ts '#fail / -> unit'
  ts '#fail / Exception -> unit'
  ts '#fail / Exception -> String -> unit'
  ts '#fail / Exception -> String -> Array[Object] -> unit'
  ts '#fork / &(-> unit)-> Integer'
  ts '#format / String -> Array[Object] -> String'
  ts '#gets / -> String'
  ts '#gets / Object -> String'
  ts '#gets / String -> Integer -> String'
  ts '#global_variables / -> Array[Symbol]'
  # ts '#gsub / Object -> String'
  ts '#iterator? / -> Boolean'
  # ts '#lambda / (Object... -> unit) -> Proc'
  ts '#load / String -> Boolean'
  ts '#load / String -> Boolean -> Boolean'
  ts '#local_variables / -> Array[Symbol]'
  ts '#loop / -> Enumerator[Object]'
  ts '#loop / &( -> unit) -> unit'
  ts '#open / String -> IO'
  ts '#open / String -> &(IO -> unit) -> unit'
  ts '#open / String -> Object... -> IO'
  ts '#open / String -> Object... -> &(IO -> unit) -> unit'
  ts '#p / -> unit'
  ts '#p / Object -> Object'
  ts '#p / Object... -> Array[Object]'
  ts '#print / Object... -> unit'
  ts '#printf / String -> Object... -> unit'
  #ts '#printf / IO -> String -> Object... -> unit'
  # ts '#proc / '
  ts '#putc / Integer -> Integer'
  ts '#puts / Object -> Object... -> unit'
  ts '#raise / -> unit'
  ts '#raise / Exception -> unit'
  ts '#raise / Exception -> String -> unit'
  ts '#raise / Exception -> String -> Array[Object] -> unit'
  ts '#rand / -> Float'
  ts '#rand[E < Numeric] / [E] -> [E]'
  ts '#readline / Object -> String'
  ts '#readline / String -> Integer -> String'
  ts '#readlines / Object -> String'
  ts '#readlines / String -> Integer -> String'
  ts '#require / String -> Boolean'
  ts '#require_relative / String -> Boolean'
  ts '#select / Array[IO] -> Array[IO]'
  ts '#select / Array[IO] -> Array[IO] -> Array[IO]'
  ts '#select / Array[IO] -> Array[IO] -> Array[IO] -> Array[IO]'
  ts '#select / Array[IO] -> Array[IO] -> Array[IO] -> Integer -> Array[IO] '
  # set_trace_func
  ts '#sleep / -> Integer'
  ts '#sleep / Integer -> Integer'
  # spawn
  ts '#sprintf / String -> Object... -> String'
  ts '#srand / -> Bignum'
  ts '#srand / -> Bignum -> Bignum'
  # sub
  ts '#syscall / Integer -> Object... -> Integer'
  # system
  ts '#test / String -> Object... -> Object'
  # throw
  # trace_var
  # trap
  # untrace_var
  ts '#warn / String -> unit'
  ts '#warn / String -> String... -> unit'
end

class Class
  ts '#initialize / -> Class'
  ts '#initialize / Class -> Class'
  ts '#allocate / -> Object'
end

class Module
  ts '#include / Module... -> Class'
end

ts 'type Enumerable[T]'
module Enumerable
  ts '#all? / &([T] -> Boolean) -> Boolean'
  ts '#any? / &([T] -> Boolean) -> Boolean'
  ts '#chunk / &([T] -> Boolean) -> Enumerator[Pair[Boolean][Array[T]]]'
  ts '#chunk / Object -> &([T] -> Object -> Boolean) -> Enumerator[Pair[Boolean][Array[T]]]'
  ts '#collect[E] / &([T] -> [E]) -> Array[E]'
  #   ts '#collect_concat / '
  ts '#count / &([T] -> Boolean) -> Integer'
  ts '#cycle / &([T] -> unit) -> unit'
  ts '#detect / -> Enumerator[T]'
  ts '#detect / &([T] -> Boolean) -> [T]'
  ts '#detect / [T] -> Enumerator[T]'
  ts '#detect / [T] -> &([T] -> Boolean) -> [T]'
  ts '#drop / Integer -> Array[T]'
  ts '#drop_while / &([T] -> Boolean) -> Array[T]'
  ts '#each_cons / Integer -> &(Array[T] -> unit) -> unit'
  ts '#each_cons / Integer -> Enumerator[Array[T]]'
  ts '#each_entry / &([T] -> unit) -> Enumerator[T]'
  ts '#each_entry / -> Enumerator[T]'
  ts '#each_slice / Integer -> &(Array[T] -> unit) -> unit'
  ts '#each_slice / Integer -> Enumerator[Array[T]]'
  ts '#each_with_index / -> Enumerator[Pair[T][Integer]]'
  ts '#each_with_index / &([T] -> Integer -> unit) -> Object'
  ts '#each_with_object[E] / [E] -> &([T] -> [E] -> unit) -> [E]'
  ts '#each_with_object[E] / [E] -> Enumerator[Pair[T][E]]'
  ts '#entries / -> Array[T]'
  # find == detect
  ts '#find / -> Enumerator[T]'
  ts '#find / &([T] -> Boolean) -> [T]'
  ts '#find / [T] -> Enumerator[T]'
  ts '#find / [T] -> &([T] -> Boolean) -> [T]'
  ts '#find_all / -> Enumerator[T]'
  ts '#find_all / &([T] -> Boolean) -> Array[T]'
  ts '#find_index / &([T] -> Boolean) -> Integer'
  ts '#find_index / [T] -> Integer'
  ts '#first / -> [T]'
  ts '#first / Integer-> Array[T]'
  #   ts '#flat_map / '
  ts '#grep / Regexp -> Array[T]'
  ts '#grep[E] / Regexp -> &([T] -> [E]) -> Array[E]'
  ts '#group_by[E] / &([T] -> [E]) -> Hash[E][Array[T]]'
  ts '#group_by / -> Enumerator[T]'
  ts '#include? / [T] -> Boolean'
  ts '#inject[E] / [E] -> Symbol -> [E]'
  ts '#inject[E] / [E] -> &(Pair[E][T] -> [E]) -> [E]'
  ts '#inject / &(Pair[T][T] -> [T]) -> [T]'
  ts '#lazy / -> Enumerator[T]'
  ts '#map[E] / &([T] -> [E]) -> Array[E]'
  ts '#max / -> [T]'
  ts '#max / &(Pair[T][T] -> Integer) -> [T]'
  ts '#max / Integer -> Array[T]'
  ts '#max / Integer -> &(Pair[T][T] -> Integer) -> Array[T]'
  ts '#max_by / &([T] -> Object) -> [T]'
  ts '#max_by / Integer -> &([T] -> Object) -> Array[T]'
  ts '#max_by / -> Enumerator[T]'
  ts '#max_by / Integer -> Enumerator[T]'
  ts '#member? / [T] -> Boolean'
  ts '#min / -> [T]'
  ts '#min / &(Pair[T][T] -> Integer) -> [T]'
  ts '#min / Integer -> Array[T]'
  ts '#min / Integer -> &(Pair[T][T] -> Integer) -> Array[T]'
  ts '#min_by / &([T] -> Object) -> [T]'
  ts '#min_by / Integer -> &([T] -> Object) -> Array[T]'
  ts '#min_by / -> Enumerator[T]'
  ts '#min_by / Integer -> Enumerator[T]'
  ts '#minmax / -> Pair[T][T]'
  ts '#minmax / &(Pair[T][T] -> Integer) -> Pair[T][T]'
  ts '#minmax_by / &([T] -> Object) -> Pair[T][T]'
  ts '#minmax_by / -> Enumerator[T]'
  ts '#none? / &([T] -> Boolean) -> Boolean'
  ts '#one? / &([T] -> Boolean) -> Boolean'
  ts '#partition / &([T] -> Boolean) -> Pair[Array[T]][Array[T]]'
  ts '#reduce[E] / [E] -> Symbol -> [E]'
  ts '#reduce[E] / [E] -> &(Pair[E][T] -> [E]) -> [E]'
  ts '#reduce / &(Pair[T][T] -> [T]) -> [T]'
  ts '#reject / &([T] -> Boolean) -> Array[T]'
  ts '#reverse_each / Object... -> Enumerator[T]'
  ts '#reverse_each / Object... -> &([T] -> unit) -> Enumerator[T]'
  ts '#select / &([T] -> Boolean) -> Array[T]'
  #   ts '#slice_after / '
  #   ts '#slice_before / '
  #   ts '#slice_when / '
  ts '#sort / &([T] -> [T] -> Integer) -> Array[T]'
  ts '#sort_by[E < Comparable] / &([T] -> [E]) -> Array[T]'
  ts '#sort_by / -> Enumerator[T]'
  ts '#take / Integer -> Array[T]'
  ts '#take_while / -> Enumerator[T]'
  ts '#take_while / &([T] -> Boolean) -> Array[T]'
  ts '#to_a / Object... -> Array[T]'
  #   ts '#to_h / Object... -> Hash'
  ts '#zip / Array[T]... -> Array[Array[T]]'
  ts '#zip / Array[T]... -> &(Array[T] -> unit) -> unit'
end

ts 'type Enumerator[T]'
class Enumerator
  ts '#initialize / &(Enumerator::Yielder[T] -> unit) -> Enumerator[T]'
  ts '#initialize / Object -> &(Enumerator::Yielder[T] -> unit) -> Enumerator[T]'
  ts '#initialize / Object -> Symbol -> Enumerator[T]'
  ts '#initialize / Object -> Symbol -> Object... -> Enumerator[T]'
  ts '#each / -> Enumerator[T]'
  ts '#each / &([T] -> unit) -> Object'
  ts '#each_with_index / -> Enumerator[Pair[T][Integer]]'
  ts '#each_with_index / &([T] -> Integer -> unit) -> Object'
  ts '#each_with_object[E] / [E] -> &([T] -> [E] -> unit) -> [E]'
  ts '#each_with_object[E] / [E] -> Enumerator[Pair[T][E]]'
  ts '#feed / [T] -> unit'
  ts '#next / -> [T]'
  ts '#next_values / -> Array[T]'
  ts '#peek / -> [T]'
  ts '#peek_values / -> Array[T]'
  ts '#rewind / ->Enumerator[T]'
  ts '#size / -> Integer'
  ts '#with_index / &([T] -> Integer -> unit) -> Object'
  ts '#with_index / -> Enumerator[Pair[T][Integer]]'
  ts '#with_index / Integer -> &([T] -> Integer -> unit) -> Object'
  ts '#with_index / Integer -> Enumerator[Pair[T][Integer]]'
  ts '#with_object[E] / [E] -> &([T] -> [E] -> unit) -> [E]'
  ts '#with_object[E] / [E] -> Enumerator[Pair[T][E]]'
end

ts 'type Enumerator::Yielder[T]'
class Enumerator::Yielder
  ts '#<< / [T] -> unit'
  ts '#yield / [T] -> unit'
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
  # Should we split this into #[] and #slice ?
  ts '#[] / Object -> Object'
  ts '#[] / Integer -> Integer -> Array[T]'
  ts '#assoc / Object -> Array[T]'
  ts '#bsearch / &([T] -> Boolean) -> [T]'
  ts '#clear / -> Array[T]'
  ts '#collect![E] / &([T] -> [E]) -> Array[E]'
  ts '#combination / Integer -> Array[Array[T]]'
  ts '#compact / -> Array[T]'
  ts '#compact! / -> Array[T]'
  ts '#concat / Array[T] -> Array[T]'
  ts '#count / [T] -> Integer'
  ts '#cycle / Integer -> &([T] -> unit) -> unit'
  ts '#delete / [T] -> &(-> [T]) -> [T]'
  ts '#delete_at / Integer -> [T]'
  ts '#delete_if / &([T] -> Boolean) -> Array[T]'
  ts '#each / &([T] -> unit) -> Array[T]'
  ts '#each / -> Enumerator[T]'
  ts '#each_index / &([Integer] -> unit) -> Array[T]'
  ts '#empty? / -> Boolean'
  ts '#eql? / Array[?] -> Boolean'
  ts '#fetch / Integer -> &(Integer ->[T]) -> [T]'
  ts '#fetch / Integer -> [T] -> [T]'
  # diff no block vs block
  ts '#fill / [T] -> Array[T]'
  ts '#fill / [T] -> Integer -> Array[T]'
  ts '#fill / [T] -> Integer -> Integer -> Array[T]'
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
  ts '#map![E] / &([T] -> [E]) -> Array[E]'
  ts '#length / -> Integer'
  ts '#pack / String -> String'
  # diff no block vs block
  ts '#permutation / -> Array[Array[T]]'
  ts '#permutation / Integer -> Array[Array[T]]'
  ts '#pop / -> [T]'
  ts '#pop / Integer -> Array[T]'
  ts '#product / Array[T]... -> Array[Array[T]]'
  ts '#push / [T]... -> Array[T]'
  # ts '#rassoc / '
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

ts 'type Pair[S][T] super Array[Object]'
class Pair < Array
  ts '.of[S][T] / [S] -> [T] -> Pair[S][T]'
  ts_ignore
  def self.of(f,s)
    Pair.new([f,s])
  end

  ts '#first / -> [S]'

  ts '#second / -> [T]'
  def second
    cast(at(1), '[T]')
  end
end

ts 'type Hash[S][T] super Enumerable[Pair[S][T]]'
class Hash
  #  ts '#map[E] / &(Pair[S][T] -> [E]) -> Array[E]'

  ts '.[] / Object... -> Hash[S][T]'
  ts '.try_convert / Object -> Hash[S][T]'
  ts '#initialize / -> Hash[S][T]'
  ts '#initialize / &(Hash[S][T] -> [S] -> unit) -> Hash[S][T]'
  ts '#initialize / [T] -> Hash[S][T]'
  #==
  # []
  ts '#[]= / [S] -> [T] -> [T]'
  ts '#any? / &([S] -> [T] -> Boolean) -> Boolean'
  ts '#assoc / [S] -> Pair[S][T]'
  unless (instance_method(:untyped_assoc) rescue false)
    alias_method :untyped_assoc, :assoc
    def assoc(k)
      res = untyped_assoc(k)
      return res if res.nil?
      Pair.('[S][T]').new(res)
    end
  end
  ts '#clear / -> Hash[S][T]'
  ts '#compare_by_identity / -> Hash[S][T]'
  ts '#compare_by_identity? / -> Boolean'
  ts '#default / -> [T]'
  ts '#default / [S] -> [T]'
  ts '#default= / [T] -> [T]'
  # ts '#default_proc / -> (Hash[S][T] -> [S] -> [K])'
  # default_proc=
  ts '#delete / [S] -> &([S] -> [T]) -> [T]'
  ts '#delete_if / &([S] -> [T] -> Boolean) -> Hash[S][T]'
  ts '#each / &([S] -> [T] -> unit) -> Hash[S][T]'
  ts '#each_key / -> Enumerator[Pair[S][T]]' # TODO: make this generic, do for other functions as well
  ts '#each_key / &([S] -> unit) -> Hash[S][T]'
  ts '#each_pair / &([S] -> [T] -> unit) -> Hash[S][T]'
  ts '#each_value / &([T] -> unit) -> Hash[S][T]'
  ts '#empty? / -> Boolean'
  #ts '#eql? / Hash[?][?] -> Boolean' -> from Object
  ts '#fetch / [S] -> &([S] -> [T]) -> [T]'
  ts '#fetch / [S] -> [T] -> [T]'
  ts '#flatten / -> Array[Object]'
  ts '#flatten / Integer -> Array[Object]'
  ts '#has_key? / [S] -> Boolean'
  ts '#has_value? / [T] -> Boolean'
  ts '#hash / -> Fixnum'
  ts '#include? / [S] -> Boolean'
  ts '#invert / -> Hash[T][S]'
  ts '#keep_if / &([S] -> [T] -> Boolean) -> Hash[S][T]'
  ts '#key / [T] -> [S]'
  ts '#key? / [S] -> Boolean'
  ts '#keys / -> Array[S]'
  ts '#length / -> Fixnum'
  ts '#member? / [S] -> Boolean'
  ts '#merge / Hash[S][T] -> Hash[S][T]'
  ts '#merge / Hash[S][T] -> &([S] -> [T] -> [T] -> [T]) -> Hash[S][T]'
  ts '#merge! / Hash[S][T] -> Hash[S][T]'
  ts '#merge! / Hash[S][T] -> &([S] -> [T] -> [T] -> [T]) -> Hash[S][T]'
  ts '#rassoc / [T] -> Pair[S][T]'
  unless (instance_method(:untyped_rassoc) rescue false)
    alias_method :untyped_rassoc, :rassoc
    def rassoc(k)
      res = untyped_rassoc(k)
      return res if res.nil?
      Pair.('[S][T]').new(res)
    end
  end
  ts '#rehash / -> Hash[S][T]'
  ts '#reject / &([S] -> [T] -> Boolean) -> Hash[S][T]'
  ts '#reject! / &([S] -> [T] -> Boolean) -> Hash[S][T]'
  ts '#replace / Hash[S][T] -> Hash[S][T]'
  ts '#select / &([S] -> [T] -> Boolean) -> Hash[S][T]'
  ts '#select! / &([S] -> [T] -> Boolean) -> Hash[S][T]'
  ts  '#shift / -> Pair[S][T]'
  unless (instance_method(:untyped_shift) rescue false)
    alias_method :untyped_shift, :shift
    def shift
      res = untyped_shift
      return res if res.nil?
      Pair.('[S][T]').new(res)
    end
  end
  ts '#size / -> Fixnum'
  ts '#store / [S] -> [T] -> [T]'
  ts '#to_a / -> Array[Pair[S][T]]'
  ts '#to_h / -> Hash[S][T]'
  ts '#to_hash / -> Hash[S][T]'
  ts '#update / Hash[S][T] -> Hash[S][T]'
  ts '#update / Hash[S][T] -> &([S] -> [T] -> [T] -> [T]) -> Hash[S][T]'
  ts '#value? / [T] -> Boolean'
  ts '#values / -> Array[T]'
  ts '#values_at / [S]... -> Array[T]'
end

class String

  include Showable

  ts '#initialize / -> String'
  ts '#initialize / String -> String'
  ts '#% / Object -> String'
  ts '#* / Integer -> String'
  ts '#+ / String -> String'
  ts '#<< / Object -> String'
  ts '#<=> / String -> Integer'
  ts '#== / Object -> Boolean'
  ts '#=== / Object -> Boolean'
  ts '#=~ / Object -> Integer'
  ts '#[] / Object -> String'
  ts '#[] / Object -> Object -> String'
  ts '#ascii_only? / -> Boolean'
  ts '#b / -> String'
  ts '#bytes / -> Array[Integer]'
  ts '#bytesize / -> Integer'
  ts '#byteslice / Object -> String'
  ts '#byteslice / Integer -> Integer -> String'
  ts '#capitalize / -> String'
  ts '#capitalize! / -> String'
  ts '#casecmp / String -> Integer'
  ts '#center / Integer -> String'
  ts '#center / Integer -> String -> String'
  ts '#chars / -> Array[String]'
  ts '#chomp / -> String'
  ts '#chomp / String -> String'
  ts '#chomp! / -> String'
  ts '#chomp! / String -> String'
  ts '#chop / -> String'
  ts '#chop! / -> String'
  ts '#chr / -> String'
  ts '#clear / -> String'
  ts '#codepoints / -> Array[Integer]'
  ts '#concat / Object -> String'
  ts '#count / String... -> Fixnum'
  ts '#crypt / String -> String'
  ts '#delete / String... -> String'
  ts '#delete! / String... -> String'
  ts '#downcase / -> String'
  ts '#downcase! / -> String'
  ts '#dump / -> String'
  ts '#each_byte / &(Fixnum -> unit) -> String'
  ts '#each_byte / -> Enumerator[Fixnum]'
  ts '#each_char / &(String -> unit) -> String'
  ts '#each_char / -> Enumerator[String]'
  ts '#each_codepoint / &(Integer -> unit) -> String'
  ts '#each_codepoint / -> Enumerator[Integer]'
  ts '#each_line / &(String -> unit) -> String'
  ts '#each_line / -> Enumerator[String]'
  ts '#each_line / String -> &(String -> unit) -> String'
  ts '#each_line / String -> Enumerator[String]'
  ts '#empty? / -> Boolean'
  ts '#encode / Object... -> String'
  ts '#encode! / Object -> Object... -> String'
  ts '#encoding / -> Encoding'
  ts '#end_with? / String... -> Boolean'
  ts '#eql? / String -> Boolean'
  ts '#force_encoding / Encoding -> String'
  ts '#getbyte / Integer -> Integer'
  ts '#gsub / Regexp -> Enumerator[String]'
  ts '#gsub / Regexp -> &(String -> String) -> String'
  ts '#gsub / Regexp -> Object -> String'
  ts '#gsub! / Regexp -> Enumerator[String]'
  ts '#gsub! / Regexp -> &(String -> String) -> String'
  ts '#gsub! / Regexp -> Object -> String'
  ts '#hash / -> Fixnum'
  ts '#hex / -> Integer'
  ts '#include? / String -> Boolean'
  ts '#index / Object -> Fixnum'
  ts '#index / Object -> Integer -> Fixnum'
  ts '#insert / Integer -> String -> String'
  ts '#inspect / -> String'
  ts '#intern / -> Symbol'
  ts '#length / -> Integer'
  ts '#lines / -> Array[String]'
  ts '#lines / String -> Array[String]'
  ts '#ljust / Integer -> String'
  ts '#ljust / Integer -> String -> String'
  ts '#lstrip / -> String'
  ts '#lstrip! / -> String'
  ts '#match / Regexp -> MatchData'
  ts '#match / Regexp -> Integer -> MatchData'
  ts '#next / -> String'
  ts '#next! / -> String'
  ts '#oct / -> Integer'
  ts '#ord / -> Integer'
  ts '#partition / Object -> Array[String]'
  ts '#prepend / String -> String'
  ts '#replace / String -> String'
  ts '#reverse / -> String'
  ts '#reverse! / -> String'
  ts '#rindex / Object -> Fixnum'
  ts '#rindex / Object -> Integer -> Fixnum'
  ts '#rjust / Integer -> String'
  ts '#rjust / Integer -> String -> String'
  ts '#rpartition / Object -> Array[String]'
  ts '#rstrip / -> String'
  ts '#rstrip! / -> String'
  ts '#scan / Regexp -> Array[String]'
  ts '#scan / Regexp -> &(String... -> unit) -> String'
  ts '#scrub / -> String'
  ts '#scrub / &(String -> String) -> String'
  ts '#scrub / String -> String'
  ts '#scrub! / -> String'
  ts '#scrub! / &(String -> String) -> String'
  ts '#scrub! / String -> String'
  ts '#setbyte / Integer -> Integer -> Integer'
  ts '#size / -> Integer'
  ts '#slice / Object -> String'
  ts '#slice / Object -> Object -> String'
  ts '#slice! / Object -> String'
  ts '#slice! / Object -> Object -> String'
  ts '#split / Object -> Array[String]'
  ts '#split / Object -> Integer -> Array[String]'
  ts '#squeeze / String... -> String'
  ts '#squeeze! / String... -> String'
  ts '#start_with? / String -> Boolean'
  ts '#strip / -> String'
  ts '#strip! / -> String'
  ts '#sub / Regexp -> Enumerator[String]'
  ts '#sub / Regexp -> &(String -> String) -> String'
  ts '#sub / Regexp -> Object -> String'
  ts '#sub! / Regexp -> Enumerator[String]'
  ts '#sub! / Regexp -> &(String -> String) -> String'
  ts '#sub! / Regexp -> Object -> String'
  ts '#succ / -> String'
  ts '#succ! / -> String'
  ts '#sum / -> Integer'
  ts '#sum / Integer -> Integer'
  ts '#swapcase / -> String'
  ts '#swapcase! / -> String'
  ts '#to_c / -> Complex'
  ts '#to_f / -> Float'
  ts '#to_i / -> Integer'
  ts '#to_i / Integer -> Integer'
  ts '#to_r / -> Rational'
  ts '#to_s / -> String'
  ts '#to_str / -> String'
  ts '#to_sym / -> Symbol'
  ts '#tr / String -> String -> String'
  ts '#tr! / String -> String -> String'
  ts '#tr_s / String -> String -> String'
  ts '#tr_s! / String -> String -> String'
  ts '#unpack / String -> String'
  ts '#upcase / -> String'
  ts '#upcase! / -> String'
  ts '#upto / String -> &(String -> unit) -> String'
  ts '#upto / String -> Enumerator[String]'
  ts '#upto / String -> Boolean -> &(String -> unit) -> String'
  ts '#upto / String -> Boolean -> Enumerator[String]'
  ts '#valid_encoding? / -> Boolean'
end

ts 'type Range[T]'
class Range
  ts '#initialize / [T] -> [T] -> Range[T]'
  ts '#initialize / [T] -> [T] -> Boolean -> Range[T]'
  ts '#== / Range[T] -> Boolean'
  ts '#=== / Range[T] -> Boolean'
  ts '#begin / -> [T]'
  ts '#bsearch / &([T] -> Boolean) -> [T]'
  ts '#cover? / [T] -> Boolean'
  ts '#each / -> Enumerator[T]'
  ts '#each / &([T] -> unit) -> Object'
  ts '#end / -> [T]'
  ts '#eql? / Range[T] -> Boolean'
  ts '#exclude_end? / -> Boolean'
  ts '#first / -> [T]'
  ts '#first / Integer -> Array[T]'
  ts '#hash / -> Fixnum'
  ts '#include? / [T] -> Boolean'
  ts '#inspect / -> String'
  ts '#last / -> [T]'
  ts '#last / Integer -> Array[T]'
  ts '#max / -> [T]'
  ts '#max / &(Pair[T][T] -> Integer) -> [T]'
  ts '#max / Integer -> Array[T]'
  ts '#max / Integer -> &(Pair[T][T] -> Integer) -> Array[T]'
  ts '#member? / [T] -> Boolean'
  ts '#min / -> [T]'
  ts '#min / &(Pair[T][T] -> Integer) -> [T]'
  ts '#min / Integer -> Array[T]'
  ts '#min / Integer -> &(Pair[T][T] -> Integer) -> Array[T]'
  ts '#size / -> Integer'
  ts '#step / &([T] -> unit) -> Range[T]'
  ts '#step / -> Enumerator[T]'
  ts '#step / Integer -> &([T] -> unit) -> Range[T]'
  ts '#step / Integer -> Enumerator[T]'
  ts '#to_s / -> String'
end

class Numeric
  ts '#% / Numeric -> Float'
  ts '#+@ / -> Numeric'
  ts '#-@ / -> Numeric'
  ts '#<=> / Numeric -> Integer'
  ts '#abs / -> Numeric'
  ts '#abs2 / -> Float'
  ts '#angle / -> Float'
  ts '#arg / -> Float'
  ts '#ceil / -> Integer'
  # ts '#coerce
  ts '#conj / -> Numeric'
  ts '#conjugate / -> Numeric'
  ts '#denominator / -> Integer'
  ts '#div / Numeric -> Integer'
  ts '#divmod / Numeric -> Array[Numeric]'
  ts '#eql? / Numeric -> Boolean'
  ts '#fdiv / Numeric -> Float'
  ts '#floor / -> Integer'
  ts '#i / -> Complex'
  ts '#imag / -> Integer'
  ts '#imaginary / -> Integer'
  #ts '#initialize_copy /
  ts '#integer? /-> Boolean'
  ts '#magnitude / -> Numeric'
  ts '#modulo / Numeric -> Array[Numeric]'
  ts '#nonzero? / -> Numeric'
  ts '#numerator / -> Integer'
  ts '#phase / -> Float'
  ts '#polar / -> Array[Numeric]'
  ts '#quo / Numeric -> Numeric'
  ts '#real / -> Numeric'
  ts '#real? / -> Boolean'
  ts '#rect / -> Array[Numeric]'
  ts '#rectangular / -> Array[Numeric]'
  ts '#remainder / Numeric -> Float'
  ts '#round / -> Numeric'
  ts '#round / Integer -> Numeric'
  #ts '#singleton_method_added'
  #ts '#step
  ts '#to_c / -> Complex'
  ts '#to_int / -> Integer'
  ts '#truncate / -> Integer'
  ts '#zero? / -> Boolean'
end

class Integer
  ts '#chr / -> String'
  ts '#chr / Encoding -> String'
  ts '#downto / Integer -> Enumerator[Integer]'
  ts '#downto / Integer -> &(Integer -> unit) -> Integer'
  ts '#even? / -> Boolean'
  ts '#gcd / Integer -> Integer'
  ts '#gcdlcm / Integer -> Array[Integer]'
  ts '#lcm / Integer -> Integer'
  ts '#next / -> Integer'
  ts '#numerator / -> Integer'
  ts '#odd? / -> Boolean'
  ts '#ord / -> Boolean'
  ts '#pred / -> Integer'
  ts '#rationalize / -> Rational'
  ts '#rationalize / Object -> Rational'
  ts '#round / -> Float'
  ts '#round / Integer -> Float'
  ts '#succ / -> Integer'
  ts '#times / &(Integer -> unit) -> Integer'
  ts '#times / -> Enumerator[Integer]'
  ts '#to_i / -> Integer'
  ts '#to_r / -> Rational'
  ts '#upto / Integer -> Enumerator[Integer]'
  ts '#upto / Integer -> &(Integer -> unit) -> Integer'

  [:+, :-, :*, :/, :**, :&, :|, :^, :[], :<<, :>>].each do |method|
    ts "##{method} / Integer -> Integer"
    define_method(method){ |_| fail StandardError.new("Error invoking abstract method Integer##{method}") }
  end
  [:~, :size, :bit_length].each do |method|
    ts "##{method} / -> Integer"
    define_method(method){ fail StandardError.new("Error invoking abstract method Integer##{method}") }
  end
end

class Float
  ts '#+@ / -> Float'
  ts '#-@ / -> Float'
  ts '#< / Float -> Boolean'
  ts '#<= / Float -> Boolean'
  ts '#> / Float -> Boolean'
  ts '#>= / Float -> Boolean'
  ts '#abs / -> Float'
  ts '#coerce / Numeric -> Array[Float]'
  ts '#fdiv / Numeric -> Float'
  ts '#finite? / -> Boolean'
  ts '#floor / -> Integer'
  ts '#hash / -> Integer'
  ts '#infinite? / -> Boolean'
  ts '#inspect / -> String'
  ts '#magnitude / -> Float'
  ts '#modulo / Numeric -> Float'
  ts '#nan? / -> Boolean'
  ts '#next_float / -> Float'
  ts '#numerator / -> Integer'
  ts '#phase / -> Float'
  ts '#prev_float / -> Float'
  ts '#quo / Numeric -> Float'
  ts '#rationalize / -> Rational'
  ts '#rationalize / Object -> Rational'
  ts '#round / -> Float'
  ts '#round / Integer -> Float'
  ts '#to_f / -> Float'
  ts '#to_i / -> Integer'
  ts '#to_int / -> Integer'
  ts '#to_r / -> Rational'
  ts '#to_s / -> String'
  ts '#truncate / -> Integer'
  ts '#zero? / -> Boolean'

  [:+, :-, :*, :/, :**].each do |method|
    ts "##{method} / Float -> Float"
  end
end


class Regexp
  ts '.compile / Object -> unit'
  ts '.compile / Object -> Object -> unit'
  ts '.compile / Object -> Object -> Object -> unit'
  ts '.escape / String -> String'
  ts '.last_match / -> MatchData'
  ts '.quote / String -> String'
  ts '.try_convert / Object -> Regexp'
  ts '.union / Array[Regexp] -> Regexp'
  ts '.union / Regexp... -> Regexp'
  ts '#initialize / Object -> unit'
  ts '#initialize / Object -> Object -> unit'
  ts '#initialize / Object -> Object -> Object -> unit'
  ts '#== / Regexp -> Boolean'
  ts '#=== / String -> Boolean'
  ts '#=~ / String -> Integer'
  ts '#casefold? / -> Boolean'
  ts '#encoding / -> Encoding'
  ts '#eql? / Regexp -> Boolean'
  ts '#fixed_encoding? / -> Boolean'
  ts '#hash / -> Fixnum'
  ts '#inspect / -> String'
  ts '#match / String -> MatchData'
  ts '#match / String -> Integer -> MatchData'
  ts '#named_captures / -> Hash[String][Array[Integer]]'
  ts '#names / -> Array[String]'
  ts '#options / -> Fixnum'
  ts '#source / -> String'
  ts '#to_s / -> String'
  ts '#~ / -> Integer'
end

class MatchData
  ts '#== / MatchData -> Boolean'
  ts '#[] / Object -> Object'
  ts '#[] / Integer -> Integer -> Array[String]'
  ts '#begin / Object -> Integer'
  ts '#captures / -> Array[String]'
  ts '#end / Object -> Array[String]'
  ts '#eql? / MatchData -> Boolean'
  ts '#hash / -> Integer'
  ts '#inspect / -> String'
  ts '#length / -> Integer'
  ts '#names / -> Array[String]'
  ts '#offset / Object -> Array[Integer]'
  ts '#post_match / -> String'
  ts '#pre_match / -> String'
  ts '#regexp / -> Regexp'
  ts '#size / -> Integer'
  ts '#string / -> String'
  ts '#to_a / -> Array[String]'
  ts '#to_s / -> String'
  ts '#values_at / Integer... -> Array[String]'
end

ts 'type Comparable[T]'
module Comparable
  ts '#<=> / [T] -> Integer'
  def <=>(_); fail StandardError.new("Error invoking abstract method Comparable#<=>"); end
  ts '#< / [T] -> Boolean'
  ts '#<= / [T] -> Boolean'
  ts '#== / [T] -> Boolean'
  ts '#> / [T] -> Boolean'
  ts '#>= / [T] -> Boolean'
  ts '#between? / [T] -> [T] -> Boolean'
end
