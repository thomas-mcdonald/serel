module Serel
  class TagScore < Base
    attribute :score, Integer
    attribute :post_count, Integer

    associations :user => :user
    finder_methods :none
  end
end