require 'spec_helper'

describe Serel::Privilege do
  it 'should get all privileges' do
    VCR.use_cassette('privileges') do
      privileges = Serel::Privilege.all
      privileges.should be_a(Array)
      privileges.each do |privlege|
        privlege.should be_a(Serel::Privilege)
      end

      privilege = privileges.first
      privilege.short_description.should == "create posts"
      privilege.description.should == "Ask and answer questions"
      privilege.reputation.should == 1
    end
  end

  it 'should not respond to .find' do
    -> { Serel::Privilege.find(1) }.should raise_error(NoMethodError)
    -> { Serel::Privilege.filter('test').find(1) }.should raise_error(NoMethodError)
  end
end