require 'spec_helper'

describe Serel::Relation do
  context '#merge' do
    it 'should merge the scope of two relations with the same class' do
      rel1 = Serel::Relation.new('badge', :plural)
      rel1.instance_variable_set(:@scope, { test: 'var' })
      rel2 = Serel::Relation.new('badge', :plural)
      rel2.instance_variable_set(:@scope, { tester: 'variety' })
      rel1.merge(rel2)

      scoping = rel1.instance_variable_get(:@scope)
      scoping[:test].should == 'var'
      scoping[:tester].should == 'variety'
    end

    it 'should raise an error on attempted merge of relations with different classes' do
      rel1 = Serel::Relation.new('badge', :plural)
      rel2 = Serel::Relation.new('comment', :plural)
      -> { rel1.merge(rel2) }.should raise_error(ArgumentError)
    end
  end
end