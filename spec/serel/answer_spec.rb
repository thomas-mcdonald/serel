require 'spec_helper'

describe Serel::Answer do
  it 'should support finding an answer' do
    VCR.use_cassette('answer-find') do
      # Pick a random awesome answer
      answer = Serel::Answer.find(16573)
      answer.should be_a(Serel::Answer)

      answer.id.should == 16573
      answer.answer_id.should == 16573
      answer.question_id.should == 16568

      answer.owner.should be_a(Serel::User)
    end
  end

  it 'should add a comments scope' do
    VCR.use_cassette('answer-comments') do
      # Random awesome answer with comments
      answer = Serel::Answer.find(29552)
      comments = answer.comments.request
      comments.should be_a(Array)
      comments.first.should be_a(Serel::Comment)
    end
  end
end