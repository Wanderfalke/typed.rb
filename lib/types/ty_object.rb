module TypedRb
  module Types

    class UncomparableTypes < TypeCheckError
      attr_reader :from, :to
      def initialize(from, to, node = nil)
        nodes = [from.node, to.node].compact
        if node
          super("Cannot compare types #{from} <=> #{to}", node)
        elsif nodes.size == 2
          super("Cannot compare types #{from} <=> #{to}", nodes)
        elsif nodes.size == 1
          super("Cannot compare types #{from} <=> #{to}", nodes.first)
        else
          super("Cannot compare types #{from} <=> #{to}", nil)
        end
      end
    end

    class TyObject < Type
      include Comparable

      attr_reader :hierarchy, :classes, :modules, :ruby_type, :with_ruby_type

      def initialize(ruby_type, node=nil, classes=[], modules=[])
        super(node)
        if ruby_type
          @ruby_type = ruby_type
          @hierarchy = ruby_type.ancestors
          @classes = @hierarchy.select{|klass| klass.instance_of?(Class) }
          @modules = @hierarchy.select{|klass| klass.instance_of?(Module) }
          @with_ruby_type = true
        else
          @ruby_type = classes.first
          @classes = classes
          @modules = modules
          @hierarchy = (modules + classes).uniq
          @with_ruby_type = false
        end
      end

      def dynamic?
        false
      end

      def generic?
        false
      end

      def check_type(_context)
        self
      end

      def defaults_to_dynamic?
        ! BasicObject::TypeRegistry.registered?(ruby_type)
      end

      def compatible?(other_type, relation = :lt)
        if other_type.is_a?(TyObject)
          begin
            if relation == :gt
              self >= other_type
            elsif relation == :lt
              self <= other_type
            end
          rescue ArgumentError
            raise UncomparableTypes.new(self, other_type)
          end
        else
          other_type.compatible?(self, relation == :lt ? :gt : :lt)
        end
      end

      def as_object_type
        self
      end

      # Non generic type, the function is alwasy going to be concrete
      def find_function_type(message, num_args)
        find_function_type_in_hierarchy(:instance, message, num_args)
      end

      def find_var_type(var)
        # This is only in case the type has been explicitely declared
        var_type = BasicObject::TypeRegistry.find(:instance_variable, ruby_type, var)
        if var_type
          var_type
        else
          # If no types has been declared, we'll find a var type in the registry
          var_type = Types::TypingContext.type_variable_for(:instance_variable, var, hierarchy)
          var_type.node = node
          var_type
        end
      end

      def find_function_type_in_hierarchy(kind, message, num_args)
        functions = BasicObject::TypeRegistry.find(kind, @hierarchy.first, message)
        initial_value = functions.detect { |fn| fn.arg_compatible?(num_args) }
        @hierarchy.drop(1).inject([@hierarchy.first, initial_value]) do |(klass, acc), type|
          if acc.nil? || acc.is_a?(TyDynamicFunction)
            functions = BasicObject::TypeRegistry.find(kind, type, message)
            maybe_function = functions.detect do |fn|
              fn.arg_compatible?(num_args)
            end
            [type, maybe_function]
          else
            [klass, acc]
          end
        end
      end

      def resolve_ruby_method(message)
        @ruby_type.instance_method(message)
      end

      def to_s
        if @with_ruby_type
          @ruby_type.name
        else
          "#{@classes.first.to_s} with [#{@modules.map(&:to_s).join(',')}]"
        end
      end

      def <=>(other)
        if other.is_a?(TyObject)
          if other.with_ruby_type
            if with_ruby_type
              compare_ruby_ruby(other)
            else
              compare_with_union(other)
            end
          else
            if with_ruby_type
              compare_with_union(other)
            else
              compare_with_union(other)
            end
          end
        else
          nil
        end
      end

      def join(other)
        common_classes = classes & other.classes
        common_modules = modules & other.modules
        if common_modules.size == 1
          TyObject.new(common_modules.first, (self.node || other.node))
        else
          TyObject.new(nil, (self.node || other.node), common_classes, common_modules)
        end
      end

      protected

      def compare_ruby_ruby(other)
        if ruby_type == NilClass && other.ruby_type == NilClass
          0
        elsif ruby_type == NilClass
          -1
        elsif other.ruby_type == NilClass
          1
        else
          if other.ruby_type == ruby_type
            0
          elsif other.hierarchy.include?(ruby_type)
            1
          elsif hierarchy.include?(other.ruby_type)
            -1
          else
            nil
            #fail UncomparableTypes.new(self, other)
          end
        end
      end

      def compare_with_union(other)
        all_those_modules_included = other.modules.all?{ |m| hierarchy.include?(m) }
        all_these_modules_included = modules.all?{ |m| other.hierarchy.include?(m) }

        if other.ruby_type == ruby_type && all_these_modules_included && all_these_modules_included
          0
        elsif other.hierarchy.include?(ruby_type) && all_these_modules_included && !all_those_modules_included
          1
        elsif hierarchy.include?(ruby_type) && all_those_modules_included && !all_these_modules_included
          -1
        else
          nil
          #fail UncomparableTypes.new(self, other)
        end
      end
    end
  end
end
