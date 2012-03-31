module Serel
  # The Answer class represents a Stack Exchange answer object.
  #
  # == Finding answers
  #
  # There are a few different ways of retrieving answers: +all+, +get+ & +find+, as well as the scopes
  # on other classes.
  #
  # === all
  # +Serel::Answer.all+
  # 
  # This should probably never be used. +all+ loads _every_ answer on the site, which, for many sites,
  # involves retrieving lots of pages. However, it's there. Feel free to use it.
  #
  # == find
  # +Serel::Answer.find(id)+
  #
  # Find an answer by its ID.
  #
  # == get
  # +Serel::Answer.get+
  #
  # Retrieves answers, applying (any) scope that has been set. In reality this won't be called as given
  # above, rather it will called at the end of a chain of scoping functions, e.g:
  #
  # +Serel::Answer.pagesize(100).sort(:votes).get+
  #
  # which would return the top 100 answers on the site.
  #
  # == {Question#answers}
  # +Serel::Question.find(id).answers.get+
  #
  # Retrieves the answers on a particular question. The call to +answers+ returns a {Relation}
  # object, which accepts all the usual relation scopes. This is true for all of the methods listed
  # below.
  #
  # == {User#answers}
  # +Serel::User.find(id).answers.get+
  # 
  # Retrieves answers by a given user
  class Answer < Base
    attribute :answer_id, Integer
    alias :id :answer_id

    attribute :body, String
    attribute :community_owned_date, DateTime
    attribute :creation_date, DateTime
    attribute :down_vote_count, Integer
    attribute :is_accepted, Boolean
    attribute :last_activity_date, DateTime
    attribute :last_edit_date, DateTime
    attribute :link, String
    attribute :locked_date, DateTime
    attribute :question_id, Integer
    attribute :score, Integer
    attribute :title, String
    attribute :up_vote_count, Integer

    associations :comments => :comment, :owner => :user
    finder_methods :every

    # Get the comments on an answer.
    # @return [Serel::Relation] A {Comment} relation scoped to the answer.
    def comments
      type(:comment).url("answers/#{id}/comments")
    end

    # Get the question this answer answers.
    #
    # Note that this method returns a question not wrapped in the {Response} wrapper.
    #
    # @return [Serel::Question] The parent {Question} for this answer.
    def question
      type(:question, :singular).url("questions/#{question_id}").get
    end

    # Get the revisions on an answer.
    # @return [Serel::Relation] A {Revision} relation scoped to the answer.
    def revisions
      type(:revision).url("posts/#{id}/revisions")
    end

    # Get the suggested edits on an answer
    # @return [Serel::Relation] A {SuggestedEdit} relation scoped to the answer.
    def suggested_edits
      type(:suggested_edit).url("posts/#{id}/suggested-edits")
    end
  end
end