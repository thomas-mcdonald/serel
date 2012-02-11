module Serel
  module FinderMethods
    def find(id)
      Serel::Request.new("#{@type}s/#{id}", build_options, @context).execute
    end

    def get
      Serel::Request.new("#{@type}s", build_options, @context).execute
    end

    def request(path, type = nil)
      @type = type if type
      Serel::Request.new(path, build_options, @context).execute
    end
  end
end
