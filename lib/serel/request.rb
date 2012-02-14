module Serel
  class Request
    def initialize(type, scoping)
      @type = type
      @scope = scoping
      @site = @scope.delete :site
      @api_key = @scope.delete :api_key
      @method = @scope.delete :url
    end

    def execute
      build_query_string
      build_request_path
      make_request
    end

    def build_query_string
      query_hash = @scope
      query_hash[:site] = @site
      query_hash[:key] = @api_key
      @query_string = query_hash.map { |k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join('&')
    end

    def build_request_path
      @path = "/2.0/#{@method}?#{@query_string}"
    end

    def make_request
      puts "making request to #{@path}"
      request = Net::HTTP::Get.new(@path)
      response = Net::HTTP.start("api.stackexchange.com") { |http| http.request(request) }
      body = Zlib::GzipReader.new(StringIO.new(response.body)).read
      body = JSON.parse(body)

      result = []
      body["items"].each do |q|
        result << Serel.const_get(@type.to_s.capitalize).new(@context, q)
      end
      result.length == 1 ? result.pop : result
    end
  end
end