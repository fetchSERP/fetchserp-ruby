# FetchSERP Ruby SDK

A lightweight, hand-crafted Ruby SDK for the FetchSERP REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "fetchserp", git: "https://github.com/fetchserp/fetchserp-ruby.git"
```

Then bundle install:

```bash
bundle install
```

## Quick Start

```ruby
require "fetchserp"

client = FetchSERP::Client.new(api_key: ENV["FETCHSERP_API_KEY"])

# Get backlinks for a domain
response = client.backlinks(domain: "example.com")
puts response.data

# Fetch Google SERP results
serp = client.serp(query: "best ruby gems", country: "us")
puts serp.data["results"]
```

The client will raise `FetchSERP::Error` on any HTTP error (network, 4xx, 5xx) so you can handle failures gracefully.

## Supported Endpoints

* `/api/v1/backlinks`
* `/api/v1/domain_emails`
* `/api/v1/domain_infos`
* `/api/v1/keywords_search_volume`
* `/api/v1/keywords_suggestions`
* `/api/v1/long_tail_keywords_generator`
* `/api/v1/page_indexation`
* `/api/v1/ranking`
* `/api/v1/scrape`
* `/api/v1/scrape_domain`
* `/api/v1/scrape_js`
* `/api/v1/scrape_js_with_proxy`
* `/api/v1/serp`
* `/api/v1/serp_html`
* `/api/v1/serp_js` & `/api/v1/serp_js/{uuid}`
* `/api/v1/serp_text`
* `/api/v1/user`
* `/api/v1/web_page_ai_analysis`
* `/api/v1/web_page_seo_analysis`

## Contributing

Bug reports and pull requests are welcome!

## License

GPL-3.0 