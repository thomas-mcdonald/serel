module Serel
  class Comment < Base
    attributes :comment_id, :body, :creation_date, :edited, :link, :post_id, :post_type, :score
    alias :id :comment_id

    associations :owner => :user, :reply_to_user => :user
    finder_methods :every

    def post
      type(:post, :singular).url("posts/#{post_id}").request
    end
  end
end