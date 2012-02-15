require 'spec_helper'

# Test classes and other unimportant stuff.
class OneAttribute < Serel::Base
  attributes :test
end

class MultipleAttribute < Serel::Base
  attributes :testing, :test_id
end


describe Serel::Base do
  it "should provide a generic [] getter for data" do
    test_value = 'abc'
    base = Serel::Base.new({})
    base.instance_variable_set(:@data, { :test => test_value })
    base[:test].should ==  test_value
  end

  it "should provide a generic []= setter for data" do
    test_value = 'abc'
    base = Serel::Base.new({})
    base[:test] = test_value
    base.instance_variable_get(:@data)[:test].should == test_value
  end

  context 'attribute definition' do
    it 'should create a getter and setter for one attribute' do
      base = OneAttribute.new({})
      base.should respond_to(:test)
      base.should respond_to(:test=)
    end

    it 'should create getters and setters for multiple attributes' do
      base = MultipleAttribute.new({})
      base.should respond_to(:testing)
      base.should respond_to(:testing=)
      base.should respond_to(:test_id)
      base.should respond_to(:test_id=)
    end

    it 'should get and, er, set' do
      base = OneAttribute.new({})
      val = 'abc'
      base.test.should_not == val
      base.test = val
      base.test.should == val
    end
  end
end