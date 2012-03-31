module Serel
  class Revision < Base
    attribute :revision_guid, String
    alias :id :revision_guid

    attribute :revision_number, Integer
    attribute :revision_type, String
    attribute :post_type, String
    attribute :post_id, Integer
    attribute :comment, String
    attribute :creation_date, DateTime
    attribute :is_rollback, Boolean
    attribute :last_body, String
    attribute :last_title, String
    attribute :last_tags, Array
    attribute :body, String
    attribute :title, String
    attribute :tags, Array
    attribute :set_community_wiki, Boolean

    associations :user => :user
    finder_methods :find
  end
end