module Serel
  class TagScore < Base
    attributes :score, :post_count
    associations :user => :user
    finder_methods :none
  end
end