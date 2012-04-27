# -*- encoding: utf-8 -*-
require 'set'

module Enumattr
  class Enums
    def initialize(&block)
      @set = Set.new
      instance_eval(&block)
      freeze
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
      @set.add Enum.new(key, value)
    end
  end
end
