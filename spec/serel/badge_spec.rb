require 'spec_helper'

describe Serel::Badge do
  it 'should be able to retrieve a list of badges' do
    VCR.use_cassette('badges') do
      badges = Serel::Badge.get
      badges.should be_a(Array)

      badge = badges.first
      badge.should be_a(Serel::Badge)
      badge.id.should == 1
      badge.id.should == badge.badge_id
      badge.badge_type.should == 'named'
      badge.link.should == 'http://gaming.stackexchange.com/badges/1/teacher'
      badge.name.should == 'Teacher'
      badge.rank.should == 'bronze'
    end
  end

  it 'should retrieve a badge by its ID' do
    VCR.use_cassette('badge-id') do
      badge = Serel::Badge.find(1)
      badge.should be_a(Serel::Badge)
      badge.name.should == 'Teacher'
    end
  end

  it 'should get only named badges' do
    VCR.use_cassette('badge-named') do
      badges = Serel::Badge.named.get
      badges.should be_a(Array)

      badges.each do |badge|
        badge.should be_a(Serel::Badge)
        badge.badge_type.should == 'named'
      end
    end
  end

  context 'recipients scope' do
    it 'should retrieve a list of badges recently awarded with recipients' do
      VCR.use_cassette('badge-recipient-sans-id') do
        badges = Serel::Badge.recipients.get
        badges.should be_a(Array)

        badges.each do |badge|
          badge.should be_a(Serel::Badge)
          badge.user.should be_a(Serel::User)
        end
      end
    end

    it 'should be able to restrict badges by IDs' do
      VCR.use_cassette('badge-recipient-with-id') do
        id = 1
        badges = Serel::Badge.recipients(id).get
        badges.should be_a(Array)

        badges.each do |badge|
          badge.should be_a(Serel::Badge)
          badge.user.should be_a(Serel::User)
          badge.id.should == id
        end
      end
    end

    it 'should be able to restrict badges by multiple IDs' do
      VCR.use_cassette('badge-recipient-with-ids') do
        badges = Serel::Badge.recipients(1, 2, 3).get
        badges.should be_a(Serel::Response)

        badges.each do |badge|
          badge.should be_a(Serel::Badge)
          badge.user.should be_a(Serel::User)
          [1,2,3].should include(badge.id)
        end
      end
    end
  end

  it 'should get only tag based badges' do
    VCR.use_cassette('badge-tags') do
      badges = Serel::Badge.tags.get
      badges.should be_a(Array)

      badges.each do |badge|
        badge.should be_a(Serel::Badge)
        badge.badge_type.should == 'tag_based'
      end
    end
  end
end