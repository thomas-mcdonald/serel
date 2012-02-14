module Serel
  class Badge < Base
    attributes :badge_id, :badge_type, :description, :link, :name, :rank
    alias :id :badge_id

    associations :user => :user

    def self.named
      url("badges/name")
    end

    def self.recipients(id = nil)
      if id
        url("badges/#{id}/recipients")
      else
        url("badges/recipients")
      end
    end

    def self.tags
      url("badges/tags")
    end
  end
end