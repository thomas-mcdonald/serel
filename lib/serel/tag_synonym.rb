module Serel
  class TagSynonym < Base
    attributes :from_tag, :to_tag, :applied_count, :last_applied_date, :creation_date
    finder_methods :none
  end
end