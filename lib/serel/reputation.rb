module Serel
  class Reputation < Base
    attribute :user_id, Integer
    attribute :post_id, Integer
    attribute :post_type, String
    attribute :vote_type, String
    attribute :title, String
    attribute :link, String
    attribute :reputation_change, Integer
    attribute :on_date, DateTime

    finder_methods :none
  end
end