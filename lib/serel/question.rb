module Serel
  class Question < Base
    attribute :question_id, Integer
    alias :id :question_id

    attribute :last_edit_date, DateTime
    attribute :creation_date, DateTime
    attribute :last_activity_date, DateTime
    attribute :locked_date, DateTime
    attribute :score, Integer
    attribute :community_owned_date, DateTime
    attribute :answer_count, Integer
    attribute :accepted_answer_id, Integer
    attribute :migrated_to, Hash
    attribute :migrated_from, Hash
    attribute :bounty_closes_date, DateTime
    attribute :bounty_amount, Integer
    attribute :closed_date, DateTime
    attribute :protected_date, DateTime
    attribute :body, String
    attribute :title, String
    attribute :tags, Array
    attribute :closed_reason, String
    attribute :up_vote_count, Integer
    attribute :down_vote_count, Integer
    attribute :favorite_count, Integer
    attribute :view_count, Integer
    attribute :link, String
    attribute :is_answered, Boolean
    associations :answers => :answer, :comments => :comment, :owner => :user

    finder_methods :every

    def self.featured
      url("questions/featured")
    end

    def self.search
      url("search")
    end

    def self.similar
      url("similar")
    end

    def self.unanswered
      url("questions/unanswered")
    end

    def self.no_answers
      url("questions/no-answers")
    end

    def answers
      type(:answer).url("questions/#{id}/answers")
    end

    def comments
      type(:comment).url("questions/#{id}/comments")
    end

    def linked
      type(:question).url("questions/#{id}/linked")
    end

    def related
      type(:question).url("questions/#{id}/related")
    end

    # Get the revisions on a question.
    # @return [Serel::Relation] A {Revision} relation scoped to the question.
    def revisions
      type(:revision).url("posts/#{id}/revisions")
    end

    # Get the suggested edits on a question
    # @return [Serel::Relation] A {SuggestedEdit} relation scoped to the question.
    def suggested_edits
      type(:suggested_edit).url("posts/#{id}/suggested-edits")
    end

    def timeline
      type(:timeline).url("questions/#{id}/timeline")
    end
  end
end