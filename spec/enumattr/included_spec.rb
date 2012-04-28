# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'user'

describe User do
  describe "class methods" do
    describe '.status_enums as #{enumattr_name}_enums' do
      subject { described_class.status_enums }

      it { should be_a Set }
      it { should have(3).items }
      it "should have Enum instances" do
        should satisfy { |enums|
          enums.all?{|item| item.is_a? Enumattr::Enums::Enum }
        }
      end
    end

    describe '.status_keys as #{enumattr_name}_keys' do
      subject { described_class.status_keys }

      it { should be_a Set }
      it { should have(3).items }
      it "should have Symbol instances" do
        should satisfy { |keys|
          keys.all?{|item| item.is_a? Symbol }
        }
      end
    end

    describe '.status_values as #{enumattr_name}_values' do
      subject { described_class.status_values }

      it { should be_a Set }
      it { should have(3).items }
      it "should have Numeric instances" do
        should satisfy { |values|
          values.all?{|item| item.is_a? Numeric }
        }
      end
    end

    describe '.status_enum(key) as #{enumattr_name}_enum(key)' do
      subject { described_class.status_enum(:active) }

      it { should be_a Enumattr::Enums::Enum }
      its(:key) { should == :active }
      its(:value) { should == 1 }
    end

    describe '.status_value(key) as #{enumattr_name}_value(key)' do
      context "present key" do
        subject { described_class.status_value(:active) }

        it { should == 1 }
      end

      context "not present key" do
        subject { described_class.status_value(:not_present_key) }

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

    describe '#status_enum as #{enumattr_name}_enum' do
      subject { user.status_enum }

      it { should be_a Enumattr::Enums::Enum }
      its(:key)   { should == :active }
      its(:value) { should == 1 }
    end

    describe '#status_key as #{enumattr_name}_key' do
      subject { user.status_key }

      it { should be_a Symbol }
      it { should == :active }
    end

    describe '#status_value as #{enumattr_name}_value' do
      subject { user.status_value }

      it { should be_a Numeric }
      it { should == 1 }
    end

    describe '#status_active? as #{enumattr_name}_#{status_key}?' do
      subject { user.status_active? }

      it { should be_true }
    end

    describe '#status_inactive? as #{enumattr_name}_#{other_status_key}?' do
      subject { user.status_inactive? }

      it { should be_false }
    end

    describe '#status_deleted? as #{enumattr_name}_#{other_status_key}?' do
      subject { user.status_deleted? }

      it { should be_false }
    end
  end
end
