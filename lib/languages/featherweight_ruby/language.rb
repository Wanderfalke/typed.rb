require_relative './parser'

module TypedRb
  module Languages
    module FeatherweightRuby
      class Language
        include Model
        include Types

        def parse(expr)
          Model::GenSym.reset
          parser = Parser.new
          parser.parse(expr)
        end

        def check_type(expr)
          expr.check_type(TypingContext.new)
        end
      end
    end
  end
end
