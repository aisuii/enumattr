# -*- encoding: utf-8 -*-
require 'set'

module Enumattr
  class Enums
    def initialize(&block)
      @set = Set.new
      instance_eval(&block)
    end

    def enums
      @set.clone
    end

    def keys
      Set.new @set.map(&:key)
    end

    def values
      Set.new @set.map(&:value)
    end

    def enum_by_key(key)
      @set.find{|enum| enum.key == key }
    end

    def enum_by_value(value)
      @set.find{|enum| enum.value == value }
    end

    private
    def enum(key, value)
      @set.add Enum.new(key, value, self)
    end

    class Enum
      attr_reader :key, :value

      def initialize(key, value, container)
        @key = key.to_sym
        @value = value
        @container = container
      end

      def enums
        @container.enums
      end

      def hash
        @key.hash
      end

      def eql?(other)
        @key == other.key
      end
    end
  end
end
