module Serel
  class Timeline < Base
    attribute :comment_id, Integer
    attribute :creation_date, DateTime
    attribute :down_vote_count, Integer
    attribute :post_id, Integer
    attribute :question_id, Integer
    attribute :revision_guid, String
    attribute :timeline_type, String
    attribute :up_vote_count, Integer

    associations :user => :user, :owner => :user
    finder_methods :every
  end
end