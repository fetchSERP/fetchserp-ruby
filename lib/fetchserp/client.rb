require "net/http"
require "uri"
require "json"
require_relative "response"

module FetchSERP
  # Client is the main entry point for interacting with the FetchSERP API
  class Client
    DEFAULT_BASE_URL = "https://www.fetchserp.com".freeze

    # @param api_key [String] Your FetchSERP API key (required)
    # @param base_url [String] Override the API base url (rarely needed)
    # @param timeout [Integer] Request timeout in seconds (default: 30)
    def initialize(api_key:, base_url: DEFAULT_BASE_URL, timeout: 30)
      raise ArgumentError, "api_key is required" if api_key.to_s.strip.empty?

      @api_key  = api_key
      @base_url = base_url
      @timeout  = timeout
    end

    ###########################################################
    # Public endpoint helpers
    ###########################################################

    def backlinks(**params)
      get("/api/v1/backlinks", params)
    end

    def domain_emails(**params)
      get("/api/v1/domain_emails", params)
    end

    def domain_infos(**params)
      get("/api/v1/domain_infos", params)
    end

    def keywords_search_volume(**params)
      get("/api/v1/keywords_search_volume", params)
    end

    def keywords_suggestions(**params)
      get("/api/v1/keywords_suggestions", params)
    end

    def long_tail_keywords_generator(**params)
      get("/api/v1/long_tail_keywords_generator", params)
    end

    def page_indexation(**params)
      get("/api/v1/page_indexation", params)
    end

    def ranking(**params)
      get("/api/v1/ranking", params)
    end

    def scrape(**params)
      get("/api/v1/scrape", params)
    end

    def scrape_domain(**params)
      get("/api/v1/scrape_domain", params)
    end

    def scrape_js(**params)
      post("/api/v1/scrape_js", params)
    end

    def scrape_js_with_proxy(**params)
      post("/api/v1/scrape_js_with_proxy", params)
    end

    def serp(**params)
      get("/api/v1/serp", params)
    end

    def serp_html(**params)
      get("/api/v1/serp_html", params)
    end

    # SERP AI Overview and AI Mode - returns AI overview and AI mode response for the query
    # Less reliable than the 2-step process but returns results in under 30 seconds
    def serp_ai_mode(**params)
      get("/api/v1/serp_ai_mode", params)
    end

    # Step 1: returns uuid
    def serp_js(**params)
      get("/api/v1/serp_js", params)
    end

    # Step 2: pass uuid param (uuid: "...")
    def serp_js_content(uuid:)
      raise ArgumentError, "uuid is required" if uuid.to_s.empty?
      get("/api/v1/serp_js/#{uuid}")
    end

    def serp_text(**params)
      get("/api/v1/serp_text", params)
    end

    def user
      get("/api/v1/user")
    end

    def web_page_ai_analysis(**params)
      get("/api/v1/web_page_ai_analysis", params)
    end

    def web_page_seo_analysis(**params)
      get("/api/v1/web_page_seo_analysis", params)
    end

    ###########################################################
    # Low-level helpers
    ###########################################################

    private

    def get(path, params = nil)
      request(:get, path, params: params)
    end

    def post(path, params = nil, body: nil)
      request(:post, path, params: params, body: body)
    end

    def request(method, path, params: nil, body: nil)
      uri = URI.join(@base_url, path)

      # merge query params
      if params&.any?
        query_hash = params.reject { |_, v| v.nil? }
        existing = URI.decode_www_form(uri.query || "")
        new_qs = query_hash.flat_map { |k, v| Array(v).map { |val| [k.to_s, val.to_s] } }
        uri.query = URI.encode_www_form(existing + new_qs)
      end

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.open_timeout = @timeout
      http.read_timeout = @timeout

      request_class = case method
                      when :get  then Net::HTTP::Get
                      when :post then Net::HTTP::Post
                      else
                        raise ArgumentError, "Unsupported HTTP method: #{method}"
                      end

      req = request_class.new(uri)
      headers.each { |k, v| req[k] = v }
      req.body = body.to_json if body

      response = perform_request_with_redirect(http, req, limit: 5)

      # Raise on HTTP error codes
      code_int = response.code.to_i
      if code_int >= 400
        raise FetchSERP::Error.new("HTTP #{code_int}", status: code_int, body: response.body)
      end

      Response.new(response)
    end

    def perform_request_with_redirect(http, req, limit: 5)
      raise FetchSERP::Error, "Too many redirects" if limit.zero?

      response = http.request(req)
      case response
      when Net::HTTPRedirection
        new_location = response["location"]
        new_uri = URI.parse(new_location)
        new_http = Net::HTTP.new(new_uri.host, new_uri.port)
        new_http.use_ssl = new_uri.scheme == "https"
        new_req = req.class.new(new_uri)
        headers.each { |k, v| new_req[k] = v }
        perform_request_with_redirect(new_http, new_req, limit: limit - 1)
      else
        response
      end
    end

    def headers
      {
        "Authorization" => "Bearer #{@api_key}",
        "Content-Type" => "application/json",
        "User-Agent" => "fetchserp-ruby-sdk/#{FetchSERP::VERSION}"
      }
    end
  end
end 