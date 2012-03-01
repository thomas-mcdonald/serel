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
    attributes_on :site_type, :name, :logo_url, :api_site_parameter, :site_url, :audience, :icon_url, :aliases, :site_state, :styling, :closed_beta_date, :open_beta_date, :launch_date, :favicon_url, :related_sites, :twitter_account, :markdown_extensions
    finder_methods :all, :get
    network_wide
  end
end