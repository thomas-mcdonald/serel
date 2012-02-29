module Serel
  # The Info class represents information about a Stack Exchange site.
  #
  # == Getting info
  # The +/info+ route accepts no parameters and requires no IDs, so the default finder methods cannot be
  # used. We therefore have a custom finder defined, {.get_info}.
  class Info < Base
    attributes :total_questions, :total_unanswered, :total_accepted, :total_answers, :questions_per_minute, :answers_per_minute, :total_comments, :total_votes, :total_badges, :badges_per_minute, :total_users, :new_active_users, :api_revision
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