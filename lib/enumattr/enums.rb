# -*- encoding: utf-8 -*-

module Enumattr
  class Enums
    attr_reader :enumattr, :base, :opts

    def initialize(enumattr, base, opts = {}, &block)
      @enumattr = enumattr
      @base     = base
      @opts     = opts.freeze
      @enums    = build_enums(&block)
      decorate @enums
    end

    def enums
      @enums.clone
    end

    def keys
      @enums.map(&:key)
    end

    def values
      @enums.map(&:value)
    end

    def enum_by_key(key)
      @enums.find{|enum| enum.key == key }
    end

    def enum_by_value(value)
      @enums.find{|enum| enum.value == value }
    end

    private
    def build_enums(&block)
      if enums_hash = @opts[:enums]
        closure = proc{ enums_hash.each{|key, value| enum key, value } }
      else
        closure = block
      end

      context = Context.new(self, &closure)
      context.instance_variable_get(:@enums)
    end

    def decorate(enums)
      if @opts.has_key?(:extend)
        enums.each{|enum| enum.extend @opts[:extend] }
      end
    end

    class Context
      def initialize(container, &closure)
        @container = container
        @enums = []
        instance_eval(&closure)
      end

      private
      def enum(key, value, *extras)
        @enums << Enum.new(@container, key, value, *extras)
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
