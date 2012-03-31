module Serel
  class Post < Base
    attribute :post_id, Integer
    alias :id :post_id

    attribute :post_type, String
    attribute :body, String
    attribute :creation_date, DateTime
    attribute :last_activity_date, DateTime
    attribute :last_edit_date, DateTime
    attribute :score, Integer
    attribute :up_vote_count, Integer
    attribute :down_vote_count, Integer

    associations :comments => :comment, :owner => :user
    finder_methods :every

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