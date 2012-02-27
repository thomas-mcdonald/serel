module Serel
  class Request
    def initialize(type, scoping, qty)
      @type = type
      @scope = scoping.dup
      @site = @scope.delete :site
      @api_key = @scope.delete :api_key
      @method = @scope.delete :url
      @qty = qty
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
      Serel::Base.logger.info "Making request to #{@path}"
      request = Net::HTTP::Get.new(@path)
      response = Net::HTTP.start("api.stackexchange.com") { |http| http.request(request) }
      body = Zlib::GzipReader.new(StringIO.new(response.body)).read
      body = JSON.parse(body)

      result = Serel::Response.new

      # Set the values of the response wrapper attributes
      %w(backoff error_id error_message error_name has_more page page_size quota_max quota_remaining total type).each do |attr|
        result.send("#{attr}=", body[attr])
      end

      # Set some response values we know about but SE might not send back
      result.page ||= (@scope[:page] || 1)
      result.page_size ||= (@scope[:pagesize] || 30)

      # Insert into the response array the items returned
      body["items"].each do |item|
        result << find_constant(@type).new(item)
      end

      if (@qty == :plural) || (result.length > 1)
        result
      else
        result.pop
      end
    end
  end
end