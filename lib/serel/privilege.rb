module Serel
  class Privilege < Base
    attributes_on :short_description, :description, :reputation
    finder_methods :all
  end
end