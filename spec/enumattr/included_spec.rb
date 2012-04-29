# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'user'
require 'admin_user'
require 'entry'

describe User, 'declare with block' do
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
    let(:user) { described_class.new(1) }

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

    describe '#status_key=(key) as #{enumattr_name}_key=(key)' do
      before do
        user.status_key = :inactive
      end

      subject { user }

      its(:status)     { should == 2 }
      its(:status_key) { should == :inactive }
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

    context "out of range value" do
      subject { user }
      before { user.status = 4 }
      its(:status_enum)      { should be_nil }
      its(:status_key)       { should be_nil }
      its(:status_value)     { should == 4 }
      its(:status_active?)   { should be_false }
      its(:status_inactive?) { should be_false }
      its(:status_deleted?)  { should be_false }
    end
  end
end


describe AdminUser,"with :on option" do
  describe 'class methods' do
    describe '.authority_enums as #{enumattr_name}_enums' do
      subject { described_class.authority_enums }

      it { should be_a Set }
      it { should have(3).items }
      it "should have Enum instances" do
        should satisfy { |enums|
          enums.all?{|item| item.is_a? Enumattr::Enums::Enum }
        }
      end
    end

    describe '.authority_keys as #{enumattr_name}_keys' do
      subject { described_class.authority_keys }

      it { should be_a Set }
      it { should have(3).items }
      it "should have Symbol instances" do
        should satisfy { |keys|
          keys.all?{|item| item.is_a? Symbol }
        }
      end
    end

    describe '.authority_values as #{enumattr_name}_values' do
      subject { described_class.authority_values }

      it { should be_a Set }
      it { should have(3).items }
      it "should have Numeric instances" do
        should satisfy { |values|
          values.all?{|item| item.is_a? Numeric }
        }
      end
    end

    describe '.authority_enum(key) as #{enumattr_name}_enum(key)' do
      subject { described_class.authority_enum(:super) }

      it { should be_a Enumattr::Enums::Enum }
      its(:key) { should == :super }
      its(:value) { should == 1 }
    end

    describe '.authority_value(key) as #{enumattr_name}_value(key)' do
      context "present key" do
        subject { described_class.authority_value(:super) }

        it { should == 1 }
      end

      context "not present key" do
        subject { described_class.authority_value(:not_present_key) }

        it { should be_nil }
      end
    end
  end


  describe "instance methods" do
    let(:user) { described_class.new(1) }

    describe "#role" do
      subject { user.role }

      it { should == 1 }
    end

    describe '#authority_enum as #{enumattr_name}_enum' do
      subject { user.authority_enum }

      it { should be_a Enumattr::Enums::Enum }
      its(:key)   { should == :super }
      its(:value) { should == 1 }
    end

    describe '#authority_key as #{enumattr_name}_key' do
      subject { user.authority_key }

      it { should be_a Symbol }
      it { should == :super }
    end

    describe '#authority_key=(key) as #{enumattr_name}_key=(key)' do
      before do
        user.authority_key = :approver
      end

      subject { user }

      its(:role) { should == 2 }
      its(:authority_value) { should == 2 }
      its(:authority_key) { should == :approver }
    end

    describe '#authority_value as #{enumattr_name}_value' do
      subject { user.authority_value }

      it { should be_a Numeric }
      it { should == 1 }
    end

    describe '#authority_super? as #{enumattr_name}_#{authority_key}?' do
      subject { user.authority_super? }

      it { should be_true }
    end

    describe '#authority_approver? as #{enumattr_name}_#{other_authority_key}?' do
      subject { user.authority_approver? }

      it { should be_false }
    end

    describe '#authority_editor? as #{enumattr_name}_#{other_authority_key}?' do
      subject { user.authority_editor? }

      it { should be_false }
    end
  end
end


describe Entry,"with :enums option" do
  describe 'class methods' do
    describe '.show_flag_enums as #{enumattr_name}_enums' do
      subject { described_class.show_flag_enums }

      it { should be_a Set }
      it { should have(2).items }
      it "should have Enum instances" do
        should satisfy { |enums|
          enums.all?{|item| item.is_a? Enumattr::Enums::Enum }
        }
      end
    end

    describe '.show_flag_keys as #{enumattr_name}_keys' do
      subject { described_class.show_flag_keys }

      it { should be_a Set }
      it { should have(2).items }
      it "should have Symbol instances" do
        should satisfy { |keys|
          keys.all?{|item| item.is_a? Symbol }
        }
      end
    end

    describe '.show_flag_values as #{enumattr_name}_values' do
      subject { described_class.show_flag_values }

      it { should be_a Set }
      it { should have(2).items }
      it "should have TrueClass or FalseClass instances" do
        should satisfy { |values|
          values.all?{|item| item.is_a? TrueClass or item.is_a? FalseClass }
        }
      end
    end

    describe '.show_flag_enum(key) as #{enumattr_name}_enum(key)' do
      subject { described_class.show_flag_enum(:opened) }

      it { should be_a Enumattr::Enums::Enum }
      its(:key) { should == :opened }
      its(:value) { should == true }
    end

    describe '.show_flag_value(key) as #{enumattr_name}_value(key)' do
      context "present key" do
        subject { described_class.show_flag_value(:opened) }

        it { should == true }
      end

      context "not present key" do
        subject { described_class.show_flag_value(:not_present_key) }

        it { should be_nil }
      end
    end
  end


  describe "instance methods" do
    let(:entry) { described_class.new(true) }

    describe "#show_flag" do
      subject { entry.show_flag }

      it { should == true }
    end

    describe '#show_flag_enum as #{enumattr_name}_enum' do
      subject { entry.show_flag_enum }

      it { should be_a Enumattr::Enums::Enum }
      its(:key)   { should == :opened }
      its(:value) { should == true }
    end

    describe '#show_flag_key as #{enumattr_name}_key' do
      subject { entry.show_flag_key }

      it { should be_a Symbol }
      it { should == :opened }
    end

    describe '#show_flag_key=(key) as #{enumattr_name}_key=(key)' do
      before do
        entry.show_flag_key = :closed
      end

      subject { entry }

      its(:show_flag) { should == false }
      its(:show_flag_value) { should == false }
      its(:show_flag_key) { should == :closed }
    end

    describe '#show_flag_value as #{enumattr_name}_value' do
      subject { entry.show_flag_value }

      it { should be_a TrueClass }
      it { should == true }
    end

    describe '#show_flag_opened? as #{enumattr_name}_#{show_flag_key}?' do
      subject { entry.show_flag_opened? }

      it { should be_true }
    end

    describe '#show_flag_closed? as #{enumattr_name}_#{other_show_flag_key}?' do
      subject { entry.show_flag_closed? }

      it { should be_false }
    end
  end
end
