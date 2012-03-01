module Serel
  class Inbox < Base
    attributes_on :item_type, :question_id, :answer_id, :comment_id, :title, :creation_date, :is_unread, :site, :body, :link
    finder_methods :none
  end
end