# -*- encoding: utf-8 -*-
require 'spec_helper'

describe Enumattr::Enum do
  let(:one_enum)      { Enumattr::Enum.new(:my_key, 1) }
  let(:same_key_enum) { Enumattr::Enum.new(:my_key, 2) }
  let(:another_enum)  { Enumattr::Enum.new(:another, 3) }

  describe "getters" do
    subject { one_enum }
    its(:key)  { should == :my_key }
    its(:value) { should == 1 }
  end

  describe "in hash key" do
    context "when hash has same key enum as hash key" do
      subject do
        hash = {}
        hash[one_enum]       = 1
        hash[same_key_enum]  = 2 # only value overrided
        hash[another_enum]   = 3
        hash
      end

      its(:keys) { should     include one_enum      }
      its(:keys) { should_not include same_key_enum }
      its(:keys) { should     include another_enum  }

      its(:values) { should_not include 1 }
      its(:values) { should     include 2 }
      its(:values) { should     include 3 }

      it "should have 2 items" do
        subject.should have(2).items
      end
    end
  end
end
