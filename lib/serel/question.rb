module Serel
  class Question < Base
    attributes :question_id, :accepted_answer_id, :answer_count, :body, :bounty_amount, :bounty_closes_date, :closed_reason, :community_owned_date, :creation_date, :down_vote_count, :favourite_count, :last_activity_date, :last_edit_date, :link, :locked_date, :migrated_to, :migrated_from, :protected_date, :score, :tags, :title, :up_vote_count, :view_count
    associations :answers => :answer, :comments => :comment, :owner => :user
    alias :id :question_id
    finder_methods :every

    def self.featured
      url("questions/featured")
    end

    def self.unanswered
      url("questions/unanswered")
    end

    def self.no_answers
      url("questions/no-answers")
    end

    def answers
      type(:answer).url("questions/#{@id}/answers")
    end

    def comments
      type(:comment).url("questions/#{@id}/comments")
    end

    def linked
      type(:question).url("questions/#{@id}/linked")
    end

    def related
      type(:question).url("questions/#{@id}/related")
    end

    def timeline
      type(:timeline).url("questions/#{@id}/timeline")
    end
  end
end