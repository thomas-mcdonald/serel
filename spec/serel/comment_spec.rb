require 'spec_helper'

describe Serel::Comment do
  it 'should retrieve a single comment by ID' do
    VCR.use_cassette('comment') do
      comment = Serel::Comment.find(63977)
      comment.id.should == comment.comment_id
      comment.creation_date.should == 1325033236
      comment.edited.should == false
      comment.post_id.should == 44287
      comment.score.should == 8
      comment.owner.should be_a(Serel::User)
    end
  end

  it 'should retrieve a list of comments' do
    VCR.use_cassette('comments') do
      comments = Serel::Comment.get
      comments.should be_a(Array)

      comments.each do |comment|
        comment.should be_a(Serel::Comment)
        comment.owner.should be_a(Serel::User)
      end
    end
  end

  it 'should retrieve the post given a call to #post' do
    VCR.use_cassette('comment-post') do
      comment = Serel::Comment.find(63977)
      post = comment.post
      post.should be_a(Serel::Post)
    end
  end
end