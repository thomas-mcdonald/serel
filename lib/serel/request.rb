module Serel
  class Request
    def initialize(type, scoping, qty)
      @type = type
      @scope = scoping.dup
      @site = @scope.delete :site
      @api_key = @scope.delete :api_key
      raise Serel::NoAPIKeyError, 'You must configure Serel with an API key before you can make requests' if @api_key == nil
      @method = @scope.delete :url
      @network = @scope.delete :network
      @qty = qty
    end

    def execute
      build_query_string
      build_request_path
      make_request
    end

    def build_query_string
      query_hash = @scope
      unless @network
        query_hash[:site] = @site
      end
      query_hash[:key] = @api_key
      @query_string = query_hash.map { |k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join('&')
    end

    def build_request_path
      @path = "/2.0/#{@method}?#{@query_string}"
    end

    def make_request
      Serel::Base.logger.info "Making request to #{@path}"
      http = Net::HTTP.new('api.stackexchange.com', 443)
      http.use_ssl = true
      response = http.get(@path)
      body = JSON.parse(response.body.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: ''))

      result = Serel::Response.new

      # Set the values of the response wrapper attributes
      %w(backoff error_id error_message error_name has_more page page_size quota_max quota_remaining total type).each do |attr|
        result.send("#{attr}=", body[attr])
      end

      # Set some response values we know about but SE might not send back
      result.page ||= (@scope[:page] || 1)
      result.page_size ||= (@scope[:pagesize] || 30)

      # If any items were returned, iterate over the results and populate the response
      if body["items"]
        body["items"].each do |item|
          result << Serel.const_get(@type.to_s.classify).new(item)
        end
      end

      if (@qty == :plural) || (result.length > 1)
        result
      else
        result.pop
      end
    end
  end
end
