module Serel
  class TagWiki < Base
    attribute :tag_name, String
    attribute :body, String
    attribute :excerpt, String
    attribute :body_last_edit_date, DateTime
    attribute :excerpt_last_edit_date, DateTime

    associations :last_body_editor => :user, :last_excerpt_editor => :user
    finder_methods :none
  end
end