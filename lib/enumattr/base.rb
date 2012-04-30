# -*- encoding: utf-8 -*-

module Enumattr
  module Base
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      private
      def enumattr(enumattr_name, options = {}, &block)
        if options[:enums]
          closure = Proc.new do
            options[:enums].each{|key, value| enum key, value }
          end
        else
          closure = block
        end

        context = options.merge(:enumattr => enumattr_name, :base => self)

        enumattrs[enumattr_name] = Enums.new(context, &closure)
        enumattr_bases[enumattr_name] = options[:on] || enumattr_name

        define_enumattr_class_methods enumattr_name
        define_enumattr_instance_methods enumattr_name
      end

      def enumattrs
        @enumattrs ||= {}
      end

      def enumattr_bases
        @enumattr_bases ||= {}
      end

      def define_enumattr_class_methods(enumattr_name)
        method_prefix = "#{enumattr_name}_"

        enumattr_class_methods = Module.new do
          define_method("#{method_prefix}enums") do
            enumattrs[enumattr_name].enums
          end

          define_method("#{method_prefix}keys") do
            enumattrs[enumattr_name].keys
          end

          define_method("#{method_prefix}values") do
            enumattrs[enumattr_name].values
          end

          define_method("#{method_prefix}enum") do |key|
            enumattrs[enumattr_name].enum_by_key(key)
          end

          define_method("#{method_prefix}value") do |key|
            enum = enumattrs[enumattr_name].enum_by_key(key)
            enum && enum.value
          end
        end

        extend enumattr_class_methods
      end

      def define_enumattr_instance_methods(enumattr_name)
        enums = enumattrs[enumattr_name]
        method_prefix = "#{enumattr_name}_"
        enumattr_base = enumattr_bases[enumattr_name]

        define_method("#{method_prefix}enum") do
          value = send enumattr_base
          enums.enum_by_value(value)
        end

        define_method("#{method_prefix}key") do
          enum = send "#{method_prefix}enum"
          enum && enum.key
        end

        define_method(:"#{method_prefix}value") do
          send enumattr_base
        end

        # setter by key
        define_method("#{method_prefix}key=") do |new_key|
          new_enum = enums.enum_by_key(new_key)
          new_value = new_enum && new_enum.value
          send "#{enumattr_base}=", new_value
        end

        # Query methods
        enums.enums.each do |enum|
          define_method("#{method_prefix}#{enum.key}?") do
            value = send enumattr_base
            value == enum.value
          end
        end
      end
    end
  end
end
