# -*- encoding: utf-8 -*-

class Entry
  include Enumattr::Base

  attr_accessor :show_flag

  enumattr :show_flag, :enums => {:opened => true, :closed => false}

  def initialize(show_flag)
    @show_flag = show_flag
  end
end
