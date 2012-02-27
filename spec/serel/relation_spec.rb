require 'spec_helper'

describe Serel::Relation do
  context '#merge' do
    it 'should merge the scope of two relations with the same class' do
      rel1 = new_relation('badge')
      rel1.instance_variable_set(:@scope, { test: 'var' })
      rel2 = new_relation('badge')
      rel2.instance_variable_set(:@scope, { tester: 'variety' })
      rel1.merge(rel2)

      scoping = rel1.instance_variable_get(:@scope)
      scoping[:test].should == 'var'
      scoping[:tester].should == 'variety'
    end

    it 'should raise an error on attempted merge of relations with different classes' do
      rel1 = new_relation('badge')
      rel2 = new_relation('comment')
      -> { rel1.merge(rel2) }.should raise_error(ArgumentError)
    end
  end

  context '#filter' do
    it 'should set the filter scope' do
      rel = new_relation('badge')
      rel.filter('withbody')
      rel.scoping[:filter].should == 'withbody'
    end

    it 'should convert filters passed as symbols to strings' do
      rel = new_relation('badge')
      rel.filter(:withbody)
      rel.scoping[:filter].should == 'withbody'
    end
  end
end