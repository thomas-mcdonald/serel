module Serel
  class TagSynonym < Base
    attribute :from_tag, String
    attribute :to_tag, String
    attribute :applied_count, Integer
    attribute :last_applied_date, DateTime
    attribute :creation_date, DateTime

    finder_methods :none
  end
end