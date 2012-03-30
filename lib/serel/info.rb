module Serel
  # The Info class represents information about a Stack Exchange site.
  #
  # == Getting info
  # The +/info+ route accepts no parameters and requires no IDs, so the default finder methods cannot be
  # used. We therefore have a custom finder defined, {.get_info}.
  class Info < Base
    attribute :total_questions, Integer
    attribute :total_unanswered, Integer
    attribute :total_accepted, Integer
    attribute :total_answers, Integer
    attribute :questions_per_minute, Float
    attribute :answers_per_minute, Float
    attribute :total_comments, Integer
    attribute :total_votes, Integer
    attribute :total_badges, Integer
    attribute :badges_per_minute, Float
    attribute :total_users, Integer
    attribute :new_active_users, Integer
    attribute :api_revision, String

    associations :site => :site
    finder_methods :none

    # Gets information about the current site.
    #
    # It is best practice to aggresively cache the returned values with a TTL of at least 3600 seconds.
    #
    # @return [Serel::Info] Information about the site
    def self.get_info
      new_relation(:info, :singular).url("info").request
    end
  end
end