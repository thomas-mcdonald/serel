module Serel
  class TagWiki < Base
    attributes_on :tag_name, :body, :excerpt, :body_last_edit_date, :excerpt_last_edit_date
    associations :last_body_editor => :user, :last_excerpt_editor => :user
    finder_methods :none
  end
end