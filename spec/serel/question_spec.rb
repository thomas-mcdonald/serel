require 'spec_helper'

describe Serel::Question do
  it 'should support finding an question and accessing its attributes' do
    VCR.use_cassette('question-find') do
      # Pick a random awesome question
      question = Serel::Question.find(44903)
      question.should be_a(Serel::Question)

      question.id.should == 44903

      question.owner.should be_a(Serel::User)
    end
  end

  it 'should get the answers for the question' do
    VCR.use_cassette('question-answers') do
      question = Serel::Question.find(44903)
      answers = question.answers
      answers.get.first.should be_a(Serel::Answer)
    end
  end

  it 'should get the comments on a question' do
    VCR.use_cassette('question-comments') do
      # Random awesome question with comments
      question = Serel::Question.find(44903)
      comments = question.comments.get
      comments.should be_a(Array)
      comments.each do |comment|
        comment.should be_a(Serel::Comment)
      end
    end
  end

  it 'should get the revisions on a question' do
    VCR.use_cassette('question-revisions') do
      # question with multiple revisions
      question = Serel::Question.find(34055)
      revisions = question.revisions.get
      revisions.should be_a(Array)
      revisions.each do |rev|
        rev.should be_a(Serel::Revision)
      end
    end
  end

  it 'should get the suggested edits on an answer' do
    VCR.use_cassette('question-suggested-edits') do
      question = Serel::Question.find(44903)
      edits = question.suggested_edits.get
      edits.should be_a(Array)
      edits.each do |edit|
        edit.should be_a(Serel::SuggestedEdit)
      end
    end
  end
end