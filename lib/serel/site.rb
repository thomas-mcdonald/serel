module Serel
  # The Site class represents a Stack Exchange site.
  #
  # == Finding Sites
  #
  # Sites can be retrieved using +all+ and +get+.
  #
  # === all
  #   Serel::Site.all
  #
  # Automatically paginates through the list of sites and returns an array of every Stack Exchange site.
  #
  # == get
  #   Serel::Site.get
  #
  # Retrieves a page of sites, applying any scopes that have previously been defined.
  class Site < Base
    attribute :site_type, String
    attribute :name, String
    attribute :logo_url, String
    attribute :api_site_parameter, String
    attribute :site_url, String
    attribute :audience, String
    attribute :icon_url, String
    attribute :aliases, Array
    attribute :site_state, String
    attribute :styling, Hash
    attribute :closed_beta_date, DateTime
    attribute :open_beta_date, DateTime
    attribute :launch_date, DateTime
    attribute :favicon_url, String
    attribute :related_sites, Hash
    attribute :twitter_account, String
    attribute :markdown_extensions, Array

    finder_methods :all, :get
    network_wide
  end
end