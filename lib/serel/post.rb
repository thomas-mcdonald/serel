module Serel
  class Post < Base
    attributes :post_id, :post_type, :body, :creation_date, :last_activity_date, :last_edit_date, :score, :up_vote_count, :down_vote_count
    alias :id :post_id

    associations :comments => :comment, :owner => :user

    def comments
      type(:comment).url("posts/#{id}/comments")
    end

    def revisions
      type(:revision).url("posts/#{id}/revisions")
    end

    def suggested_edits
      type(:suggested_edit).url("posts/#{id}/suggested-edits")
    end
  end
end