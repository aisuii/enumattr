# -*- encoding: utf-8 -*-
require 'spec_helper'

describe Enumattr::Enums do
  shared_examples "Enumattr::Enums find methods" do
    describe "enum_by_key" do
      context "with :test1" do
        subject { enums.enum_by_key(:test1) }
        it { should be_a Enumattr::Enums::Enum }
        its(:key) { should == :test1 }
        its(:value) { should == 1 }
      end
    end

    describe "enum_by_value" do
      context "with 1" do
        subject { enums.enum_by_value(1) }
        it { should be_a Enumattr::Enums::Enum }
        its(:key) { should == :test1 }
        its(:value) { should == 1 }
      end
    end

    describe "enum_by_key :test1" do
      subject { enums.enum_by_key(:test1) }
      it { should be_a Enumattr::Enums::Enum }
      its(:key) { should == :test1 }
      its(:value) { should == 1 }
    end

    describe "enum_by_key :not_registered" do
      subject { enums.enum_by_key(:not_registered) }
      it { should be_nil }
    end
  end

  context "with enumattr, base and block" do
    class EnumsTest1
      include Enumattr::Base

      attr_accessor :test

      enumattr :test do
        enum :test1, 1
        enum :test2, 2
        enum :test3, 3
        enum :test4, 4
        enum :test5, 5
      end
    end

    let(:enums) { EnumsTest1.instance_eval("enumattrs[:test]") }

    describe "attributes" do
      subject { enums }
      its(:base) { should == EnumsTest1 }
      its(:enums) { should have(5).enums }
      its(:opts) { should be_empty }
      its(:keys) { should == [:test1, :test2, :test3, :test4, :test5] }
      its(:values) { should == [1, 2, 3, 4, 5] }
    end

    include_examples "Enumattr::Enums find methods"

  end

  context "with enumattr, base and :enums option" do
    class EnumsTest2
      include Enumattr::Base

      attr_accessor :test

      enumattr :test, :enums => {:test1 => 1, :test2 => 2, :test3 => 3}
    end

    let(:enums) { EnumsTest2.instance_eval("enumattrs[:test]") }

    describe "attributes" do
      subject { enums }
      its(:base) { should == EnumsTest2 }
      its(:enums) { should have(3).enums }
      its(:opts) { should_not be_empty }
      its(:keys) { should == [:test1, :test2, :test3] }
      its(:values) { should == [1, 2, 3] }
      # if Ruby version <= 1.8.7
      # its(:keys) { should =~ [:test1, :test2, :test3] }
      # its(:values) { should =~ [1, 2, 3] }
    end

    include_examples "Enumattr::Enums find methods"
  end

  context "with enumattr, base and :extend option" do
    module NameExteision
      def name
        @extras.first
      end
    end

    class EnumsTest3
      include Enumattr::Base

      attr_accessor :test

      enumattr :test, :extend => NameExteision do
        enum :test1, 1, "test1 name"
        enum :test2, 2, "test2 name"
        enum :test3, 3, "test3 name"
        enum :test4, 4, "test4 name"
      end
    end

    let(:enums) { EnumsTest3.instance_eval("enumattrs[:test]") }

    describe "attributes" do
      subject { enums }
      its(:base) { should == EnumsTest3 }
      its(:enums) { should have(4).enums }
      its(:opts) { should_not be_empty }
      its(:keys) { should == [:test1, :test2, :test3, :test4] }
      its(:values) { should == [1, 2, 3, 4] }
    end

    include_examples "Enumattr::Enums find methods"

    describe "enum_by_key :test1" do
      describe "extension method" do
        subject { enums.enum_by_key(:test1) }
        its(:name) { should == "test1 name" }
      end
    end
  end
end
