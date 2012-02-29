require 'spec_helper'

describe Serel::Site do
  it 'should retrieve a page of sites' do
    VCR.use_cassette('sites') do
      sites = Serel::Site.get
      sites.should be_a(Serel::Response)

      sites.each do |site|
        site.should be_a(Serel::Site)
      end
    end
  end

  it 'should not respond to .find' do
    -> { Serel::Privilege.find }.should raise_error(NoMethodError)
    -> { Serel::Privilege.filter('test').find }.should raise_error(NoMethodError)
  end
end