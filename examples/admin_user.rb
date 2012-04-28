# -*- encoding: utf-8 -*-

class AdminUser
  include Enumattr::Base

  attr_accessor :role

  enumattr :authority, :on => :role do
    enum :super,    1
    enum :approver, 2
    enum :editor,   3
  end

  def initialize(role)
    @role = role
  end
end
