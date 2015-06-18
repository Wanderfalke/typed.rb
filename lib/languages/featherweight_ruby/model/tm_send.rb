# -*- coding: utf-8 -*-
require_relative '../model'

module TypedRb
  module Languages
    module FeatherweightRuby
      module Model
        # message send
        class TmSend < Expr
          attr_accessor :receiver, :message, :args
          def initialize(receiver, message, args, node)
            super(node)
            @receiver = receiver
            @message = message
            @args = args
          end

          def to_s
            if args.size == 0
              "[#{receiver} <- #{message}"
            else
              "[#{receiver} <- #{message}(#{args.map(&to_s).join(',')})"
            end
          end

          def rename(from_binding, to_binding)
            # rename receiver
            if !@receiver.nil? && @receiver != :self
              @receiver = @receiver.rename(from_binding, to_binding)
            end
            # rename default args
            @args = @args.map { |arg| arg.rename(from_binding, to_binding) }
            self
          end

          def check_type(context)
            if receiver.nil? && message.to_s == 'ts'
            # ignore, => type annotation
            elsif message == :new && !singleton_object_type(receiver, context).nil?
              check_instantiation(context)
            elsif receiver == :self || receiver.nil?
              # self.m(args), m(args), m
              check_type_no_explicit_receiver(context)
            else
              # x.m(args)
              check_type_explicit_receiver(context)
            end
          end

          def singleton_object_type(receiver,context)
            receiver_type = if (receiver.nil? || receiver == :self)
                              context.get_type_for(:self)
                            else
                              receiver.check_type(context)
                            end
            if receiver_type.instance_of?(TypedRb::Languages::FeatherweightRuby::Types::TySingletonObject)
              receiver_type
            else
              nil
            end
          end

          # we received new, but we look for initialize in the class,
          # not the singleton class.
          # we then run the regular application,
          # but we return the class type instead of the return type
          # for the constructor application (should be unit/nil).
          def check_instantiation(context)
            self_type = singleton_object_type(receiver,context).as_object_type
            function_type = self_type.find_function_type(:initialize)
            if function_type.nil?
              error_message = "Error typing message, type information for #{receiver_type} constructor found."
              fail TypeError.new(error_message, self)
            else
              # function application
              @message = :initialize
              check_application(self_type, function_type, context)
              self_type
            end
          end

          def check_type_no_explicit_receiver(context)
            self_type = context.get_type_for(:self) # check message in self type -> application
            function_type = self_type.find_function_type(message)
            if function_type.nil?
              if context.get_type_for(message) && args.size == 0
                # m -> m is local variable
                context.get_type_for(message)
              else
                error_message = "Error typing message, type information for #{self_type}:#{message} found."
                fail TypeError.new(error_message, self)
              end
            else
              # function application
              check_application(self_type, function_type, context)
            end
          end

          def check_type_explicit_receiver(context)
            receiver_type = receiver.check_type(context)
            function_type = receiver_type.find_function_type(message)
            if function_type.nil?
              error_message = "Error typing message, type information for #{receiver_type}:#{message} found."
              fail TypeError.new(error_message, self)
            else
              # function application
              check_application(receiver_type, function_type, context)
            end
          end

          def check_application(receiver_type, function_type, context)
            function_arg_types = function_type.from
            function_return_type = function_type.to
            method = receiver_type.resolve_ruby_method(message)
            method.parameters.each_with_index do |(arg_type, arg_name), index|
              argument = args[index]
              function_arg_type = function_arg_types[index]
              if argument.nil? && arg_type != :opt
                fail TypeError.new("Missing mandatory argument #{arg_name} in #{receiver_type}##{message}", self)
              else
                unless argument.nil? # opt if this is nil
                  argument_type = argument.check_type(context)
                  unless argument_type.compatible?(function_arg_type)
                    error_message = "Incompatible argument #{arg_name} in #{receiver_type}##{message},"
                    error_message = "#{error_message} #{function_arg_type} expected, #{argument_type} found"
                    fail TypeError.new(error_message, self)
                  end
                end
              end
            end
            function_return_type
          end
        end
      end
    end
  end
end
