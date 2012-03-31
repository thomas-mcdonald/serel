module Serel
  class SuggestedEdit < Base
    attribute :suggested_edit_id, Integer
    alias :id :suggested_edit_id

    attribute :post_id, Integer
    attribute :post_type, String
    attribute :body, String
    attribute :title, String
    attribute :tags, Array
    attribute :comment, String
    attribute :creation_date, DateTime
    attribute :approval_date, DateTime
    attribute :rejection_date, DateTime

    associations :proposing_user => :user
    finder_methods :every
  end
end