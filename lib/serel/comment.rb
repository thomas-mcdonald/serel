module Serel
  # The Comment class represents a Stack Exchange comment object.
  #
  # == Finding Comments
  #
  # Comments can be retrieved using any of the standard finder methods: +all+, +get+ & +find+.
  #
  # === all
  #   Serel::Comment.all
  #
  # It is recommended that you don't use this method, since most of the time it is overkill.
  # Automatically paginating through all the comments on a site, even 100 comments at a time, will take
  # a long time and a lot of requests. It is almost certainly better to use one of the other finder
  # methods, but this is here for the sake of completion. If you need to access every comment, the data
  # dump and data explorer are your friends.
  #
  # ==find
  #   Serel::Comment.find(id)
  # 
  # Retrieves a comment or comments by ID.
  #
  # == get
  #   Serel::Comment.get
  #
  # Retrieves a page of comment results, applying any scopes that have previously been defined.
  #
  # == {Answer#comments}
  #  Serel::Answer.find(id).comments.get
  #
  # Retrieves a page of comments on the specified answer.
  #
  # == {Post#comments}
  #  Serel::Post.find(id).comments.get
  #
  # Retrieves a page of comments on the specified post.
  #
  # == {Question#comments}
  #  Serel::Question.find(id).comments.get
  #
  # Retrieves a page of comments on the specified question.
  #
  # == {User#comments}
  #  Serel::User.find(id).comments.get
  #  Serel::User.find(id).comments(other_id).get
  #
  # Retrieves a page of comments by the specified user. If the optional +other_id+ parameter is passed
  # then only comments in reply to +other_id+ are included.
  #
  # == {User#mentioned}
  #  Serel::User.find(id).mentioned.get
  #
  # Retrieves a page of comments mentioning the specified user.
  class Comment < Base
    attribute :comment_id, Integer
    alias :id :comment_id

    attribute :post_id, Integer
    attribute :creation_date, DateTime
    attribute :post_type, String
    attribute :score, Integer
    attribute :edited, Boolean
    attribute :body, String
    attribute :link, String

    associations :owner => :user, :reply_to_user => :user
    finder_methods :every

    # Retrieves the post that this comment is on.
    #
    # Note that this returns the post, rather than returning a {Serel::Response} wrapped array.
    # @return [Serel::Post] The post the comment is on.
    def post
      type(:post, :singular).url("posts/#{post_id}").get
    end
  end
end