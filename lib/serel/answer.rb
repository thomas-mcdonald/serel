module Serel
  class Answer < Base
    attributes :answer_id, :body, :community_owned_date, :creation_date, :down_vote_count, :is_accepted, :last_activity_date, :last_edit_date, :link, :locked_date, :question_id, :score, :title, :up_vote_count
    alias :id :answer_id

    associations :comments => :comment, :owner => :user

    def comments
      type(:comment).url("answers/#{id}/comments")
    end

    def question
      type(:question, :singular).url("questions/#{question_id}").request
    end

    def revisions
      type(:revision).url("posts/#{id}/revisions")
    end

    def suggested_edits
      type(:suggested_edit).url("posts/#{id}/suggested-edits")
    end
  end
end