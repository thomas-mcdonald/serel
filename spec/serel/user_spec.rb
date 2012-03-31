require 'spec_helper'

describe Serel::User do
  it 'should get a user by ID' do
    VCR.use_cassette('user') do
      # Pick the best user on Gaming
      user = Serel::User.find(821)
      user.should be_a(Serel::User)

      user.id.should == 821
      user.user_type.should == 'registered'
      user.display_name.should == 'Thomas McDonald'
      user.profile_image.should be_a(String)
      user.reputation_change_day.should be_a(Fixnum)
      user.reputation_change_week.should be_a(Fixnum)
      user.reputation_change_month.should be_a(Fixnum)
      user.reputation_change_year.should be_a(Fixnum)
      user.is_employee.should == false
      user.link.should be_a(String)
      user.account_id.should == 86843
      user.badge_counts.should be_a(Hash)
    end
  end

  it 'should get the moderators' do
    VCR.use_cassette('user-moderators') do
      users = Serel::User.moderators.get
      users.should be_a(Serel::Response)

      users.each do |user|
        user.should be_a(Serel::User)
        user.user_type.should == 'moderator'
      end
    end
  end

  it 'should get the elected moderators' do
    VCR.use_cassette('user-elected-moderators') do
      users = Serel::User.elected_moderators.get
      users.should be_a(Serel::Response)

      users.each do |user|
        user.should be_a(Serel::User)
        user.user_type.should == 'moderator'
      end
    end
  end

  it "should get a users' answers" do
    VCR.use_cassette('user-answers') do
      user = Serel::User.find(821)
      answers = user.answers.get
      answers.should be_a(Serel::Response)

      answers.each do |answer|
        answer.should be_a(Serel::Answer)
        answer.owner.id.should == user.id
      end
    end
  end

  it "should get a users' badges" do
    VCR.use_cassette('user-badges') do
      user = Serel::User.find(821)
      badges = user.badges.get
      badges.should be_a(Serel::Response)

      badges.each do |badge|
        badge.should be_a(Serel::Badge)
        badge.user.id.should == user.id
      end
    end
  end

  it "should get a users' comments" do
    VCR.use_cassette('users-comments') do
      user = Serel::User.find(821)
      comments = user.comments.get
      comments.should be_a(Serel::Response)

      comments.each do |comment|
        comment.should be_a(Serel::Comment)
        comment.owner.id.should == user.id
      end
    end
  end

  it "should get a users' comments to another user" do
    VCR.use_cassette('users-comments-to') do
      user = Serel::User.find(821)
      comments = user.comments(255).get
      comments.should be_a(Serel::Response)

      comments.each do |comment|
        comment.should be_a(Serel::Comment)
        comment.owner.id.should == user.id
        comment.reply_to_user.id.should == 255
      end
    end
  end

  it "should get a users' favourites" do
    VCR.use_cassette('users-favouries') do
      user = Serel::User.find(821)
      favourites = user.favorites.get
      favourites.should be_a(Serel::Response)

      favourites.each do |fav|
        fav.should be_a(Serel::Question)
      end
    end
  end

  it 'should get the comments a user was mentioned in' do
    VCR.use_cassette('users-mentions') do
      user = Serel::User.find(821)
      mentions = user.mentioned.get
      mentions.should be_a(Serel::Response)

      mentions.each do |comment|
        comment.should be_a(Serel::Comment)
        comment.reply_to_user.id.should == user.id
      end
    end
  end

  it "should get a users' privileges" do
    VCR.use_cassette('users-privileges') do
      user = Serel::User.find(821)
      privileges = user.privileges.get
      privileges.should be_a(Serel::Response)

      privileges.each do |priv|
        priv.should be_a(Serel::Privilege)
      end
    end
  end

  it "should get a users' questions" do
    VCR.use_cassette('users-questions') do
      user = Serel::User.find(821)
      questions = user.questions.get
      questions.should be_a(Serel::Response)

      questions.each do |question|
        question.should be_a(Serel::Question)
        question.owner.id.should == user.id
      end
    end
  end

  it "should get a users' reputation changes" do
    VCR.use_cassette('users-reputation') do
      user = Serel::User.find(821)
      rep_changes = user.reputation.get
      rep_changes.should be_a(Serel::Response)

      rep_changes.each do |rep|
        rep.should be_a(Serel::Reputation)
        rep.user_id.should == user.id
      end
    end
  end

  it "should get a users' suggested edits" do
    VCR.use_cassette('users-suggested-edits') do
      user = Serel::User.find(3936)
      suggested_edits = user.suggested_edits.get
      suggested_edits.should be_a(Serel::Response)

      suggested_edits.each do |edit|
        edit.should be_a(Serel::SuggestedEdit)
        edit.proposing_user.id.should == user.id
      end
    end
  end

  it "should get a users' active tags" do
    VCR.use_cassette('user-tags') do
      user = Serel::User.find(821)
      tags = user.tags.get
      tags.should be_a(Serel::Response)

      tags.each do |tag|
        tag.should be_a(Serel::Tag)
      end
    end
  end

  # TODO: check if fixed
  # Disabled while http://stackapps.com/q/3194/1031
  # it "should get a users' top answers in a tag" do
  #   VCR.use_cassette('user-top-answers-single-tag') do
  #     user = Serel::User.find(821)
  #     answers = user.top_answers_on('battlefield-3').get
  #     answers.should be_a(Serel::Response)
  # 
  #     answers.each do |answer|
  #       answer.should be_a(Serel::Answer)
  #       answer.owner.id.should == user.id
  #     end
  #   end
  # end
  # 
  # it "should get a users' top answers in several tags" do
  #   VCR.use_cassette('user-top-answers-multiple-tags') do
  #     user = Serel::User.find(821)
  #     answers = user.top_answers_on('battlefield-3', 'minecraft').get
  #     answers.should be_a(Serel::Response)
  # 
  #     answers.each do |answer|
  #       answer.should be_a(Serel::Answer)
  #       answer.owner.id.should == user.id
  #     end
  #   end
  # end

  it "should get a user' top questions in a tag" do
    VCR.use_cassette('user-top-questions-in-tag') do
      user = Serel::User.find(821)
      questions = user.top_questions_on('battlefield-3').get
      questions.should be_a(Serel::Response)

      questions.each do |question|
        question.should be_a(Serel::Question)
        question.owner.id.should == user.id
      end
    end
  end
end