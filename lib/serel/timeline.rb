module Serel
  class Timeline < Base
    attributes :timeline_type, :question_id, :post_id, :comment_id, :revision_guid, :up_vote_count, :down_vote_count, :creation_date
    associations :user => :user, :owner => :user
    finder_methods :every
  end
end