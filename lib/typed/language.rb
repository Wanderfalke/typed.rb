require_relative './runtime/ast_parser'
require 'colorize'

module TypedRb
  class Language
    include Model
    include Types

    attr_reader :unification_result

    def check(expr)
      restore_prelude
      $TYPECHECK = true
      eval(expr, TOPLEVEL_BINDING)
      $TYPECHECK = false
      TypedRb.log(binding, :debug, 'Normalize top level')
      ::BasicObject::TypeRegistry.normalize_types!
      TypingContext.clear(:top_level)
      check_result = check_type(parse(expr))
      ::BasicObject::TypeRegistry.check_super_type_annotations
      @unification_result = run_unification
      check_result
    end

    def gen_bin_prelude
      File.open(File.join(File.dirname(__FILE__), 'prelude_registry.bin'), 'w') do |f|
        f.write(Marshal.dump(::BasicObject::TypeRegistry.send(:registry)))
      end
      File.open(File.join(File.dirname(__FILE__), 'prelude_generic_registry.bin'), 'w') do |f|
        f.write(Marshal.dump(::BasicObject::TypeRegistry.send(:generic_types_registry)))
      end
      File.open(File.join(File.dirname(__FILE__), 'prelude_existential_registry.bin'), 'w') do |f|
        f.write(Marshal.dump(::BasicObject::TypeRegistry.send(:existential_types_registry)))
      end
    end

    def load_bin_prelude
      old_value = $TYPECHECK
      $TYPECHECK = false
      require_relative('./prelude')
      $TYPECHECK = old_value
      ::BasicObject::TypeRegistry.clear
      File.open(File.join(File.dirname(__FILE__), 'prelude_registry.bin'), 'r') do |f|
        ::BasicObject::TypeRegistry.registry =  Marshal.load(f.read)
      end
      File.open(File.join(File.dirname(__FILE__), 'prelude_generic_registry.bin'), 'r') do |f|
        ::BasicObject::TypeRegistry.generic_types_registry = Marshal.load(f.read)
      end
      File.open(File.join(File.dirname(__FILE__), 'prelude_existential_registry.bin'), 'r') do |f|
        ::BasicObject::TypeRegistry.existential_types_registry = Marshal.load(f.read)
      end
      ::BasicObject::TypeRegistry.clear_parsing_registries
      true
    rescue
      false
    end

    def restore_prelude
      unless load_bin_prelude
        ::BasicObject::TypeRegistry.clear
        $TYPECHECK = true
        load File.join(File.dirname(__FILE__), 'prelude.rb')
        $TYPECHECK = false
        ::BasicObject::TypeRegistry.normalize_types!
        gen_bin_prelude
        TypingContext.clear(:top_level)
        ::BasicObject::TypeRegistry.clear_parsing_registries
      end
    end

    def check_files(files, raise_errors = false)
      ::BasicObject::TypeRegistry.clear
      $TYPECHECK = true
      prelude_path = File.join(File.dirname(__FILE__), 'prelude.rb')
      load prelude_path
      Kernel.reset_dependencies
      Kernel.with_dependency_tracking do
        files.each { |file| load file if file != prelude_path }
      end
      ordered_files = Kernel.computed_dependencies.select do |file|
        files.include?(file)
      end
      ordered_files += files.select { |file| !ordered_files.include?(file) }
      $TYPECHECK = false
      TypedRb.log(binding, :debug, 'Normalize top level')
      ::BasicObject::TypeRegistry.normalize_types!
      TypingContext.clear(:top_level)
      check_result = nil
      errors = {}
      errors_accum = {}
      ordered_files.each do |file|
        $TYPECHECK_FILE = file
        expr = File.open(file, 'r').read
        begin
          check_result = check_type(parse(expr))
          print '.'.green
        rescue TypedRb::Types::UncomparableTypes, TypedRb::TypeCheckError => e
          print 'E'.red
          hash = e.to_s.hash
          unless errors_accum[hash]
            errors_accum[hash] = true
            errors_for_file = errors[file] || []
            errors_for_file << e
            errors[file] = errors_for_file
          end
        end
      end
      top_level_errors = []
      begin
        ::BasicObject::TypeRegistry.check_super_type_annotations
        @unification_result = run_unification
      rescue TypedRb::Types::UncomparableTypes, TypedRb::TypeCheckError => e
        hash = e.to_s.hash
        unless errors_accum[hash]
          errors_accum[hash] = true
          print 'E'.red
          top_level_errors << e
        end
      end
      puts "\n"
      total_errors = all_errors(top_level_errors, errors)
      dynamic_warnings = TypedRb.dynamic_warnings
      if total_errors.count > 0
        puts "\nErrors:"
        report_errors(top_level_errors, errors, {})
      end
      if dynamic_warnings.count > 0
        puts "\nWarnings:"
        report_errors([], {}, dynamic_warnings)
      end
      puts "\nProcessed #{files.size} files, #{total_errors.count} errors, #{dynamic_warnings.count} warnings\n"
      check_errors(total_errors) if raise_errors
      check_result
    end

    def report_errors(top_level_errors, errors, warnings)
      files = (errors.keys||[]) + (warnings.keys||[])
      files.each do |file|
        errors_for_file = errors[file] || []
        warnings_for_file = warnings[file] || []
        errors_for_file.each do |error|
          puts "\n"
          puts error.message.red
        end
        warnings_for_file.each do |warning|
          hash = warning.to_s.hash
          unless errors_accum[hash]
            errors_accum[hash] = true
            puts "\n"
            puts warning.message.yellow
          end
        end
      end
      top_level_errors.each do |error|
        puts "\n"
        puts error.message.red
      end
    end

    def all_errors(top_level_errors, errors)
      (top_level_errors||[]) + ((errors||{}).values.reduce(&:concat) || [])
    end

    def check_errors(total_errors)
      raise total_errors.first if total_errors.count > 0
    end

    def check_file(path, raise_errors = false)
      check_files([path], raise_errors)
    end

    def parse(expr)
      Model::GenSym.reset
      parser = AstParser.new
      parser.parse(expr)
    end

    def check_type(expr)
      expr.check_type(TypingContext.top_level)
    end

    def run_unification
      constraints = Types::TypingContext.all_constraints
      unif = Types::Polymorphism::Unification.new(constraints)
      unif.run(true)
    end

    def type_variables
      TypingContext.all_variables
    end
  end
end
