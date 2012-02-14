module Serel
  module FinderMethods
    def find(id)
      url("#{@type}s/#{id}").request
    end

    def get
      url("#{@type}s").request
    end
  end
end