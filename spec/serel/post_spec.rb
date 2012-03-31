require 'spec_helper'

describe Serel::Post do
  it 'should retrive a post by ID' do
    VCR.use_cassette('post') do
      post = Serel::Post.find(16573)
      post.should be_a(Serel::Post)

      post.id.should == 16573
      post.id.should == post.post_id
      post.post_type.should == 'answer'
      post.score.should be_a(Fixnum)

      post.owner.should be_a(Serel::User)
    end
  end

  it 'should retrieve a list of posts' do
    VCR.use_cassette('posts') do
      posts = Serel::Post.get
      posts.should be_a(Array)

      posts.each do |post|
        post.should be_a(Serel::Post)
      end
    end
  end

  it 'should get the comments on the post' do
    VCR.use_cassette('post-comments') do
      post = Serel::Post.find(29552)
      comments = post.comments.get
      comments.should be_a(Array)

      comments.each do |comment|
        comment.should be_a(Serel::Comment)
      end
    end
  end

  it 'should get the revisions on the post' do
    VCR.use_cassette('post-revisions') do
      post = Serel::Post.find(34055)
      revisions = post.revisions.get
      revisions.should be_a(Array)

      revisions.each do |revision|
        revision.should be_a(Serel::Revision)
        revision.post_id.should == post.id
      end
    end
  end

  it 'should get the suggested edits on the post' do
    VCR.use_cassette('post-suggested-edits') do
      post = Serel::Post.find(14665)
      suggested_edits = post.suggested_edits.get
      suggested_edits.should be_a(Array)

      suggested_edits.each do |edit|
        edit.should be_a(Serel::SuggestedEdit)
        edit.post_id.should == post.id
      end
    end
  end
end