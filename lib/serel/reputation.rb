module Serel
  class Reputation < Base
    attributes :user_id, :post_id, :post_type, :vote_type, :title, :link, :reputation_change, :on_date
    finder_methods :none
  end
end