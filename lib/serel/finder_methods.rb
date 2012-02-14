module Serel
  module FinderMethods
    # TODO: classes potentially need to be able to disable these, for example privileges doesn't have a find by id
    # also TODO: move these back into relation. this fragmentation drive me crazy.
    def find(id)
      url("#{@type}s/#{id}").request
    end

    def get
      url("#{@type}s").request
    end
  end
end