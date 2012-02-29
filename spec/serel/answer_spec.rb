require 'spec_helper'

describe Serel::Answer do
  it 'should support finding an answer and accessing its attributes' do
    VCR.use_cassette('answer-find') do
      # Pick a random awesome answer
      answer = Serel::Answer.find(16573)
      answer.should be_a(Serel::Answer)

      answer.id.should == 16573
      answer.answer_id.should == 16573
      answer.question_id.should == 16568
      answer.is_accepted.should == true
      answer.score.should be_a(Fixnum)

      answer.owner.should be_a(Serel::User)
    end
  end

  it 'should get the question the answer is on' do
    VCR.use_cassette('answer-question') do
      answer = Serel::Answer.find(16573)
      question = answer.question
      question.should be_a(Serel::Question)
      answer.question_id.should == question.id
    end
  end

  it 'should get the comments on an answer' do
    VCR.use_cassette('answer-comments') do
      # Random awesome answer with comments
      answer = Serel::Answer.find(29552)
      comments = answer.comments.request
      comments.should be_a(Array)
      comments.each do |comment|
        comment.should be_a(Serel::Comment)
      end
    end
  end

  it 'should get the revisions on an answer' do
    VCR.use_cassette('answer-revisions') do
      answer = Serel::Answer.find(14545)
      revisions = answer.revisions.request
      revisions.should be_a(Array)
      revisions.each do |rev|
        rev.should be_a(Serel::Revision)
      end
    end
  end

  it 'should get the suggested edits on an answer' do
    VCR.use_cassette('answer-suggested-edits') do
      answer = Serel::Answer.find(14264)
      edits = answer.suggested_edits.request
      edits.should be_a(Array)
      edits.each do |edit|
        edit.should be_a(Serel::SuggestedEdit)
      end
    end
  end
end