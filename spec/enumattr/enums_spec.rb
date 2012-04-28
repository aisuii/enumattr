# -*- encoding: utf-8 -*-
require 'spec_helper'

describe Enumattr::Enums do
  let(:enums) do
    Enumattr::Enums.new do
      enum :key1, 1
      enum :key2, 2
      enum :key3, 3
    end
  end

  describe "#enums" do
    subject { enums.enums }
    it { should be_a Set }
    it { should have(3).items }
    it "should have Enumattr::Enums::Enum instances" do
      should satisfy { |enums|
        enums.all?{|item| item.is_a? Enumattr::Enums::Enum }
      }
    end
  end

  describe "#keys" do
    subject { enums.keys }
    it { should be_a Set }
    it { should have(3).items }
    it "should have Symbol instances" do
      should satisfy { |keys|
        keys.all?{|item| item.is_a? Symbol }
      }
    end
  end

  describe "#values" do
    subject { enums.values }
    it { should be_a Set }
    it { should have(3).items }
    it "should have Numeric instances" do
      should satisfy { |values|
        values.all?{|item| item.is_a? Numeric }
      }
    end
  end

  describe "find methods" do
    shared_examples "#enum_by_foo(foo) each items" do
      it { should be_a Enumattr::Enums::Enum }
      its(:key)   { should == expects[:key] }
      its(:value) { should == expects[:value] }
    end

    samples = [
      {:key => :key1, :value => 1},
      {:key => :key2, :value => 2},
      {:key => :key3, :value => 3},
    ]

    describe "#enum_by_key(key)" do
      subject { enums.enum_by_key(key) }
      samples.each do |sample|
        context "key: #{sample[:key]}" do
          let(:key) { sample[:key] }
          let(:expects) { sample }

          include_examples "#enum_by_foo(foo) each items"
        end
      end
    end

    describe "#enum_by_value(value)" do
      subject { enums.enum_by_value(value) }

      samples.each do |sample|
        context "value: #{sample[:value]}" do
          let(:value) { sample[:value] }
          let(:expects) { sample }

          include_examples "#enum_by_foo(foo) each items"
        end
      end
    end
  end

  describe Enumattr::Enums::Enum do
    subject { enums.enum_by_key(:key1) }
    its(:key) { should == :key1 }
    its(:value) { should == 1 }
    its(:enums) { should == enums.enums }
  end
end
