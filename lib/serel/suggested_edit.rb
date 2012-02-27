module Serel
  class SuggestedEdit < Base
    attributes :suggested_edit_id, :post_id, :post_type, :body, :title, :tags, :comment, :creation_date, :approval_date, :rejection_date
    alias :id :suggested_edit_id
    associations :proposing_user => :user
    finder_methods :every
  end
end