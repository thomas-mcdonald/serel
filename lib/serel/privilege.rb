module Serel
  class Privilege < Base
    attribute :short_description, String
    attribute :description, String
    attribute :reputation, Integer
    finder_methods :all
  end
end