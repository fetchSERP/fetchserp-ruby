require "json"

module FetchSERP
  # Simple wrapper to expose response JSON via `data` and raw HTTP response
  class Response
    attr_reader :http_response

    def initialize(http_response)
      @http_response = http_response
      @parsed_body = parse_body
    end

    # Returns parsed JSON body (if JSON) or raw body otherwise
    # @return [Object]
    def body
      @parsed_body
    end

    # Shortcut accessor for common API structure { "data": ... }
    def data
      if @parsed_body.is_a?(Hash) && @parsed_body.key?("data")
        @parsed_body["data"]
      else
        @parsed_body
      end
    end

    # Allow convenient hash-like access
    def [](key)
      body[key]
    end

    private

    def parse_body
      raw_body = @http_response.body

      # If body already parsed (e.g., Hash), return directly.
      return raw_body unless raw_body.is_a?(String)

      content_type = if @http_response.respond_to?(:headers)
                       @http_response.headers["content-type"].to_s
                     else
                       @http_response["content-type"].to_s
                     end
      if content_type.include?("json")
        begin
          JSON.parse(raw_body)
        rescue JSON::ParserError
          raw_body
        end
      else
        raw_body
      end
    end
  end
end 