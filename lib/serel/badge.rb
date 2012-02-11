module Serel
  class Badge < Base
    attributes :badge_id, :badge_type, :description, :link, :name, :rank
    alias :id :badge_id

    associations :user => :user

    scope :named, -> { request("badges/name", :badge) }
    scope :recipients, ->(id = nil) do
      if !id
        request("badges/recipients", :badge)
      else
        request("badges/#{id}/recipients", :badge)
      end
    end
    scope :tags, -> { request("badges/tags", :badge) }
  end
end
