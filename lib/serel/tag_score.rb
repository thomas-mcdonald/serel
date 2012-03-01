module Serel
  class TagScore < Base
    attributes_on :score, :post_count
    associations :user => :user
    finder_methods :none
  end
end