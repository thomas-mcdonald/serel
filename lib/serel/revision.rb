module Serel
  class Revision < Base
    attributes :revision_guid, :revision_number, :revision_type, :post_type, :post_id, :comment, :creation_date, :is_rollback, :last_body, :last_title, :last_tags, :body, :title, :tags, :set_community_wiki
    alias :id :revision_guid

    associations :user => :user
  end
end