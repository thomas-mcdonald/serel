module Serel
  class Inbox < Base
    attribute :item_type, String
    attribute :question_id, Integer
    attribute :answer_id, Integer
    attribute :comment_id, Integer
    attribute :title, String
    attribute :creation_date, DateTime
    attribute :is_unread, Boolean
    attribute :site, Hash
    attribute :body, String
    attribute :link, String
    finder_methods :none
  end
end