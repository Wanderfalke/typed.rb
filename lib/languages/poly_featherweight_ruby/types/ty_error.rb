module TypedRb
  module Languages
    module PolyFeatherweightRuby
      module Types
        class TyError < Type
          def to_s
            'error'
          end

          def compatible?(_relation, _other_type)
            true
          end

          def self.is?(type)
            type == TyError || type.instance_of?(TypeError)
          end
        end
      end
    end
  end
end
