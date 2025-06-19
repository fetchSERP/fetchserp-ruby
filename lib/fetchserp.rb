require_relative "fetchserp/version"
require_relative "fetchserp/error"
require_relative "fetchserp/response"
require_relative "fetchserp/client"

module FetchSERP
  class << self
    # Creates a new default client. Convenience wrapper around FetchSERP::Client.new
    #
    # @param api_key [String] Your FetchSERP API key
    # @param kwargs [Hash] Forwarded to Client.initialize
    # @return [FetchSERP::Client]
    def new(api_key:, **kwargs)
      Client.new(api_key: api_key, **kwargs)
    end
  end
end 