# -*- encoding: utf-8 -*-

module Enumattr
  class Enum
    attr_reader :key, :value

    def initialize(key, value)
      @key = key.to_sym
      @value = value
    end

    def hash
      @key.hash
    end

    def eql?(other)
      @key == other.key
    end
  end
end
