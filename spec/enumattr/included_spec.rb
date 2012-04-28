# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'user'

describe User do
  describe "class methods" do
    describe '.status_enums as #{enum_attr_name}_enums' do
      subject { described_class.status_enums }

      it { should be_a Set }
      it { should have(3).items }
      it "should have Enum instances" do
        should satisfy { |enums|
          enums.all?{|item| item.is_a? Enumattr::Enums::Enum }
        }
      end
    end

    describe '.status_keys as #{enum_attr_name}_keys' do
      subject { described_class.status_keys }

      it { should be_a Set }
      it { should have(3).items }
      it "should have Symbol instances" do
        should satisfy { |keys|
          keys.all?{|item| item.is_a? Symbol }
        }
      end
    end

    describe '.status_values as #{enum_attr_name}_values' do
      subject { described_class.status_values }

      it { should be_a Set }
      it { should have(3).items }
      it "should have Numeric instances" do
        should satisfy { |values|
          values.all?{|item| item.is_a? Numeric }
        }
      end
    end

    describe '.status_enum_by_key as #{enum_attr_name}_enum_by_key' do
      subject { described_class.status_enum_by_key(:active) }

      it { should be_a Enumattr::Enums::Enum }
      its(:key) { should == :active }
      its(:value) { should == 1 }
    end

    describe '.status_value_by_key as #{enum_attr_name}_value_by_key' do
      context "present key" do
        subject { described_class.status_value_by_key(:active) }

        it { should == 1 }
      end

      context "not present key" do
        subject { described_class.status_value_by_key(:not_present_key) }

        it { should be_nil }
      end
    end
  end


  describe "instance methods" do
    let(:user) { User.new(1) }

    describe "#status" do
      subject { user.status }

      it { should == 1 }
    end

    describe '#status_enum as #{enum_attr_name}_enum' do
      subject { user.status_enum }

      it { should be_a Enumattr::Enums::Enum }
      its(:key)   { should == :active }
      its(:value) { should == 1 }
    end

    describe '#status_key as #{enum_attr_name}_key' do
      subject { user.status_key }

      it { should be_a Symbol }
      it { should == :active }
    end

    describe '#status_value as #{enum_attr_name}_value' do
      subject { user.status_value }

      it { should be_a Numeric }
      it { should == 1 }
    end

    describe '#status_active? as #{enum_attr_name}_#{status_key}?' do
      subject { user.status_active? }

      it { should be_true }
    end

    describe '#status_suspend? as #{enum_attr_name}_#{other_status_key}?' do
      subject { user.status_suspend? }

      it { should be_false }
    end

    describe '#status_deleted? as #{enum_attr_name}_#{other_status_key}?' do
      subject { user.status_deleted? }

      it { should be_false }
    end
  end
end
