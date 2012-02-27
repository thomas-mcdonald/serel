module Serel
  class Privilege < Base
    attributes :short_description, :description, :reputation
    finder_methods :all
  end
end