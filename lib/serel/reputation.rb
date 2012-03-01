module Serel
  class Reputation < Base
    attributes_on :user_id, :post_id, :post_type, :vote_type, :title, :link, :reputation_change, :on_date
    finder_methods :none
  end
end