# -*- encoding: utf-8 -*-

class User
  include Enumattr::Base

  attr_accessor :status

  enum_attr_for :status do
    enum :active,  1
    enum :suspend, 2
    enum :deleted, 3
  end

  def initialize(status)
    @status = status
  end
end
