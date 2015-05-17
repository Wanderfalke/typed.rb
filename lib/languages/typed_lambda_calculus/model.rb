# -*- coding: utf-8 -*-
module TypedRb
  module Languages
    module TypedLambdaCalculus
      module Model

        class GenSym
          COUNTS = {} unless defined?(COUNTS)

          def self.reset
            COUNTS.clear
          end

          def self.next(x="_gs")
            count = COUNTS[x] || 1
            sym = "#{x}[[#{count}"
            COUNTS[x] = count + 1
            sym
          end

          def self.resolve(gx)
            if gx.index('[[')
              orig, count = gx.split("[[")
              if count == '1'
                orig
              else
                gx
              end
            else
              gx
            end
          end
        end

        class TypeError < StandardError
          attr_reader :term
          def initialize(msg, term)
            super(msg)
            @term = term
          end
        end

        class Expr
          attr_reader :line, :col, :type
          def initialize(node, type = nil)
            @line = node.location.line
            @col = node.location.column
            @type = type
          end

          def check_type(_context)
            fail(TypeError, 'Unknown type', self) if @type.nil?
            @type
          end

          def rename(_from_binding, _to_binding)
            self
          end
        end

        # integers
        class TmInt < Expr
          attr_accessor :val
          def initialize(node)
            super(node,Types::TyInteger.new)
            @val = node.children.first
          end

          def to_s
            "#{@val}"
          end
        end

        # booleans
        class TmBoolean < Expr
          attr_accessor :val
          def initialize(node)
            super(node, Types::TyBoolean.new)
            @val = node.type == 'true' ? true : false
          end

          def to_s
            if @val
              'True'
            else
              'False'
            end
          end
        end

        # strings
        class TmString < Expr
          attr_accessor :val
          def initialize(node)
            super(node,Types::TyString.new)
            @val = node.children.first
          end

          def to_s
            "'#{@val.gsub("'","\\'")}'"
          end
        end

        # floats
        class TmFloat < Expr
          attr_accessor :val
          def initialize(node)
            super(node,Types::TyFloat.new)
            @val = node.children.first
          end

          def to_s
            "#{@val}"
          end
        end

        class TmIfElse < Expr
          def initialize(node, condition_expr, then_expr, else_expr)
            super(node, nil)
            @condition_expr = condition_expr
            @then_expr = then_expr
            @else_expr = else_expr
          end

          def rename(from_binding, to_binding)
            @condition_expr.rename(from_binding, to_binding)
            @then_expr.rename(from_binding, to_binding)
            @else_expr.rename(from_binding, to_binding)
            self
          end

          def check_type(context)
            if @condition_expr.check_type(context).compatible?(Types::TyBoolean)
              then_expr_type = @then_expr.check_type(context)
              else_expr_type = @else_expr.check_type(context)
              if then_expr_type.compatible?(else_expr_type)
                else_expr_type
              else
              fail TypeError.new('Arms of conditional have different types', self)
              end
            else
              fail TypeError.new('Expected Bool type in if conditional expression', @condition_expr)
            end
          end

          def to_s
            "if #{@condition_expr} then\n  #{@then_expr}\nelse\n  #{@else_expr}\nend\n"
          end
        end

        # variable
        class TmVar < Expr

          attr_accessor :index, :val

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
            context.get_type_for(@val)
          end
        end

        # abstraction
        class TmAbs < Expr
          attr_accessor :head, :term
          def initialize(head, term, type,node)
            super(node, type)
            if type.nil?
              fail StandardError, 'Missing type annotation for abstraction'
            end
            @head = head
            @term = term
          end

          def to_s
              "λ#{GenSym.resolve(@head)}:#{type}.#{@term}"
          end

          def rename(from_binding, to_binding)
            if(@head != from_binding)
              term.rename(from_binding,to_binding)
            end
            self
          end

          def check_type(context)
            context = context.add_binding(head,type.from)
            type_term = term.check_type(context)
            if type.to.nil? || type_term.compatible?(type.to)
              type.to = type_term
              type
            else
              error_message = "Error abstraction type, exepcted #{type} got #{type.from} -> #{type_term}"
              fail TypeError.new(error_message, self)
            end
          end
        end

        # application
        class TmApp < Expr
          attr_accessor :abs,:subs
          def initialize(abs, subs, node)
            super(node)
            @abs = abs
            @subs = subs
          end

          def rename(from_binding, to_binding)
            @abs.rename(from_binding, to_binding)
            @subs.rename(from_binding, to_binding)
            self
          end

          def check_type(context)
            abs_type = abs.check_type(context)
            subs_type = subs.check_type(context)
            if abs_type.compatible?(Types::TyFunction)
              if abs_type.from.compatible?(subs_type)
                abs_type.to
              else
                fail TypeError.new("Error in application expected #{abs_type.from} got #{subs_type}", self)
              end
            else
              fail TypeError.new("Error in application expected Function type got #{abs_type}", self)
            end
          end

          def to_s
            "(#{@abs} #{@subs})"
          end
        end

        #TmLet.new(binding, map(term,context), node)
        class TmLet < Expr
          attr_accessor :binding, :term
          def initialize(binding, term, node)
            super(node)
            @binding = binding
            @term = term
          end

          def to_s
            "let #{GenSym.resolve(@binding)} = #{@term}"
          end

          def rename(from_binding, to_binding)
            # let binding shadows variables in the closure
            if @binding == from_binding
              @binding = from_binding
            end
            @term.rename(from_binding, to_binding)
            self
          end

          def check_type(context)
            binding_type = @term.check_type(context)
            context.add_binding!(@binding,binding_type)
          end
        end

        class TmSequencing < Expr
          attr_accessor :terms
          def initialize(terms,node)
            super(node)
            @terms = terms.reject(&:nil?)
          end

          def to_s
            printing_order_terms= @terms.reverse
            initial = "λ:#{GenSym.next}:Unit.#{printing_order_terms.first}"
            printing_order_terms.drop(1).inject(initial) do |acc, term|
              param = GenSym.next
              "(#{acc} λ:#{param}:Unit.#{term})"
            end
          end

          def rename(from_binding, to_binding)
            @terms.each{|term| term.rename(from_binding, to_binding) }
            self
          end

          def check_type(context)
            @terms.reduce {|_,term| term.check_type(context) }
          end
        end
      end
    end
  end
end
