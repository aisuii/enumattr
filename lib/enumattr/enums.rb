# -*- encoding: utf-8 -*-
require 'set'

module Enumattr
  class Enums
    attr_reader :enumattr, :base, :opts

    def initialize(enumattr, base, opts = {}, &block)
      @enumattr = enumattr
      @base     = base
      @opts     = opts.freeze
      @set      = enum_set(&block)
      decorate
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
    def enum_set(&block)
      if enums_hash = @opts[:enums]
        closure = proc{ enums_hash.each{|key, value| enum key, value } }
      else
        closure = block
      end

      context = Context.new(self, &closure)
      context.instance_variable_get(:@set)
    end

    def decorate
      if @opts.has_key?(:extend)
        @set.each{|enum| enum.extend @opts[:extend] }
      end
    end

    class Context
      def initialize(container, &closure)
        @container = container
        @set = Set.new
        instance_eval(&closure)
      end

      private
      def enum(key, value, *extras)
        @set.add Enum.new(@container, key, value, *extras)
      end
    end

    class Enum
      attr_reader :key, :value

      def initialize(container, key, value, *extras)
        @container = container
        @key       = key.to_sym
        @value     = value
        @extras    = extras
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
