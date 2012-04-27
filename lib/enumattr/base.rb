# -*- encoding: utf-8 -*-

module Enumattr
  module Base
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      private
      def enum_attr_for(enum_attr_name, &block)
        enum_attrs[enum_attr_name] = Enums.new(&block)
        define_class_methods enum_attr_name
        define_instance_methods enum_attr_name
        define_instance_query_methods enum_attr_name
      end

      def enum_attrs
        @enum_attrs ||= {}
      end

      def define_class_methods(enum_attr_name)
        enums = enum_attrs[enum_attr_name]
        method_prefix = "#{enum_attr_name}_"

        mod = Module.new do
          define_method("#{method_prefix}enums") do
            enums.enums
          end

          define_method("#{method_prefix}keys") do
            enums.keys
          end

          define_method("#{method_prefix}values") do
            enums.values
          end

          define_method("#{method_prefix}enum_by_key") do |key|
            enums.enum_by_key(key)
          end

          define_method("#{method_prefix}value_by_key") do |key|
            enum = enums.enum_by_key(key)
            enum.value
          end
        end

        extend mod
      end

      def define_instance_methods(enum_attr_name)
        enums = enum_attrs[enum_attr_name]
        method_prefix = "#{enum_attr_name}_"

        define_method("#{method_prefix}enum") do
          value = __send__ enum_attr_name
          enums.enum_by_value(value)
        end

        define_method("#{method_prefix}key") do
          enum = __send__ "#{method_prefix}enum"
          enum.key
        end

        alias_method :"#{method_prefix}value", enum_attr_name
      end

      def define_instance_query_methods(enum_attr_name)
        enums = enum_attrs[enum_attr_name]
        method_prefix = "#{enum_attr_name}_"

        enums.enums.each do |enum|
          define_method("#{method_prefix}#{enum.key}?") do
            value = __send__ enum_attr_name
            value == enum.value
          end
        end
      end
    end
  end
end
