require 'spec_helper'

# Test classes and other unimportant stuff.
class OneAttribute < Serel::Base
  attributes :test
end


describe Serel::Base do
  it "should provide a [] getter for data" do
    test_value = 'abc'
    base = Serel::Base.new({}, {})
    # Set the internal information
    base.instance_variable_set(:@data, { :test => test_value })
    base[:test].should eq(test_value)
  end

  it "should provide a []= setter for data" do
    test_value = 'abc'
    base = Serel::Base.new({}, {})
    base[:test] = test_value
    base.instance_variable_get(:@data)[:test].should eq(test_value)
  end

  it "should create instance getters and setters for an attribute when attribute is called in class definition with a single symbol" do
    base = Tester.new({}, {})
    base.should respond_to(:test)
    base.should respond_to(:test=)
  end
end