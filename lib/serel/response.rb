module Serel
  class Response < Array
    attr_accessor :backoff, :error_id, :error_message, :error_name, :has_more, :page, :page_size, :quota_max, :quota_remaining, :total, :type
  end
end