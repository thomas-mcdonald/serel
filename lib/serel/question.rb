module Serel
  class Question < Base
    attributes :question_id, :accepted_answer_id, :answer_count, :body, :bounty_amount, :bounty_closes_date, :closed_reason, :community_owned_date, :creation_date, :down_vote_count, :favourite_count, :last_activity_date, :last_edit_date, :link, :locked_date, :migrated_to, :migrated_from, :protected_date, :score, :tags, :title, :up_vote_count, :view_count
    associations :answers => :answer, :comments => :comment, :owner => :user
    alias :id :question_id

    def answers
      type(:answer).url("questions/#{@id}/answers")
    end
  end
end