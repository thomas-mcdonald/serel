module Serel
  class Context
    def initialize(site, api_key = nil)
      @site = site.to_sym
      @api_key = api_key
    end

    attr_reader :api_key, :site
  end
end
