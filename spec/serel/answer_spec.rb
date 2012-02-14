require 'spec_helper'

describe Serel::Answer do
  context 'the class' do
    it 'should support finding an answer and accessing its attributes' do
      VCR.use_cassette('answer-find') do
        # Pick a random awesome answer
        answer = Serel::Answer.find(16573)
        answer.should be_a(Serel::Answer)

        answer.id.should == 16573
        answer.answer_id.should == 16573
        answer.question_id.should == 16568
        answer.is_accepted.should == true
        answer.score.should == 23

        answer.owner.should be_a(Serel::User)
      end
    end
  end

  context 'an instance' do
    it 'should have a comments scope' do
      VCR.use_cassette('answer-comments') do
        # Random awesome answer with comments
        answer = Serel::Answer.find(29552)
        comments = answer.comments.request
        comments.should be_a(Array)
        comments.first.should be_a(Serel::Comment)
      end
    end

    it 'should be able to get the question' do
      VCR.use_cassette('answer-question') do
        answer = Serel::Answer.find(16573)
        question = answer.question
        question.should be_a(Serel::Question)
        answer.question_id.should == question.id
      end
    end
  end
end