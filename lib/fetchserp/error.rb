module FetchSERP
  # Generic error class for all FetchSERP related exceptions
  class Error < StandardError
    attr_reader :status, :body

    # @param message [String]
    # @param status [Integer, nil] HTTP status code if available
    # @param body [String, Hash, nil] Raw response body (string or parsed JSON)
    def initialize(message = nil, status: nil, body: nil)
      super(message)
      @status = status
      @body = body
    end
  end
end 