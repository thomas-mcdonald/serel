require 'spec_helper'

describe Serel::Tag do
  it 'should get a tag by name' do
    VCR.use_cassette('tag') do
      tag = Serel::Tag.find_by_name('battlefield-3')

      tag.name.should == 'battlefield-3'
      tag.count.should be_a(Fixnum)
      tag.is_required.should == false
      tag.is_moderator_only.should == false
      tag.has_synonyms.should == false
    end
  end

  it 'should get only required badges' do
    VCR.use_cassette('tag-required') do
      configure('meta.gaming')
      tags = Serel::Tag.required.get
      tags.should be_a(Serel::Response)

      tags.each do |tag|
        tag.should be_a(Serel::Tag)
        tag.is_required.should == true
      end
    end
  end

  it 'should get moderator only badges' do
    VCR.use_cassette('tag-moderator-only') do
      configure('meta.gaming')
      tags = Serel::Tag.moderator_only.get
      tags.should be_a(Serel::Response)

      tags.each do |tag|
        tag.should be_a(Serel::Tag)
        tag.is_moderator_only.should == true
      end
    end
  end

  it 'should get related badges' do
    VCR.use_cassette('tag-related') do
      tags = Serel::Tag.find_by_name('battlefield-3').related.get
      tags.should be_a(Serel::Response)

      tags.each do |tag|
        tag.should be_a(Serel::Tag)
      end
    end
  end
end