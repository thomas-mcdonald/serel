require 'spec_helper'

# Test classes and other unimportant stuff.
class OneAttribute < Serel::Base
  attribute :test, String
end

class MultipleAttribute < Serel::Base
  attribute :testing, String
  attribute :test_id, String
end

describe Serel::Base do
  it "should provide a generic [] getter for data" do
    test_value = 'abc'
    base = OneAttribute.new({})
    base.instance_variable_set(:@data, { :test => test_value })
    base[:test].should ==  test_value
  end

  it "should provide a generic []= setter for data" do
    test_value = 'abc'
    base = OneAttribute.new({})
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

  it 'should set the configuration options' do
    Serel::Base.config(:stackoverflow, 'test')
    Serel::Base.api_key.should == 'test'
    Serel::Base.site.should == :stackoverflow
  end

  context '#new_relation' do
    it 'should return a new relation scoped to the class' do
      relation = Serel::Badge.new_relation
      relation.type.should == 'badge'
      relation.klass.should == Serel::Badge
      relation.qty.should == :singular
    end

    it 'should work with camelcased classes' do
      relation = Serel::SuggestedEdit.new_relation
      relation.type.should == 'suggested_edit'
      relation.klass.should == Serel::SuggestedEdit
    end

    it 'should scope the relation class to the first argument' do
      relation = Serel::Base.new_relation(:badge)
      relation.type.should == 'badge'
      relation.klass.should == Serel::Badge
    end

    it 'even with snake case' do
      relation = Serel::Base.new_relation(:suggested_edit)
      relation.type.should == 'suggested_edit'
      relation.klass.should == Serel::SuggestedEdit
    end

    it 'should honour the first argument, even when calling from a class' do
      relation = Serel::Badge.new_relation(:suggested_edit)
      relation.type.should == 'suggested_edit'
      relation.klass.should == Serel::SuggestedEdit
    end

    it 'should pass the qty argument through to the relation' do
      relation = Serel::Badge.new_relation(:suggested_edit, :plural)
      relation.qty.should == :plural
    end
  end
end