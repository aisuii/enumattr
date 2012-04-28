# -*- encoding: utf-8 -*-

module Enumattr
  module Base
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      private
      def enumattr(enumattr_name, &block)
        enumattrs[enumattr_name] = Enums.new(self, &block)

        define_enumattr_class_methods enumattr_name
        define_enumattr_instance_methods enumattr_name
      end

      def enumattrs
        @enumattrs ||= {}
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

        define_method("#{method_prefix}enum") do
          value = __send__ enumattr_name
          enums.enum_by_value(value)
        end

        define_method("#{method_prefix}key") do
          enum = __send__ "#{method_prefix}enum"
          enum.key
        end

        alias_method :"#{method_prefix}value", enumattr_name

        # Query methods
        enums.enums.each do |enum|
          define_method("#{method_prefix}#{enum.key}?") do
            value = __send__ enumattr_name
            value == enum.value
          end
        end
      end
    end
  end
end
