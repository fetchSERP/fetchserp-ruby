# FetchSERP Ruby SDK

A lightweight, hand-crafted Ruby SDK for the FetchSERP REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "fetchserp", "~> 0.1"
```

Then bundle install:

```bash
bundle install
```

## Authentication

An API key is required for **all** requests. You can create a free account and grab your key at <https://fetchserp.com/> — every new account starts with **250 free credits** so you can test the endpoints immediately.

Set it in your environment (recommended):

```bash
export FETCHSERP_API_KEY="your-secret-token"
```

or pass it directly when instantiating the client:

```ruby
client = FetchSERP.new(api_key: "your-secret-token")
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

# Get ranking positions for a domain/keyword
ranking = client.ranking(keyword: "serp api", domain: "fetchserp.com", pages_number: 5)
puts ranking.data["results"]
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
* `/api/v1/serp_ai_mode`
* `/api/v1/serp_html`
* `/api/v1/serp_js` & `/api/v1/serp_js/{uuid}`
* `/api/v1/serp_text`
* `/api/v1/user`
* `/api/v1/web_page_ai_analysis`
* `/api/v1/web_page_seo_analysis`

## API Reference

Below is the full list of convenience helpers exposed by `FetchSERP::Client`. All methods return a `FetchSERP::Response` object which exposes
`data`, `body` and the raw Net::HTTP response via `http_response`.

| Ruby method | Underlying REST endpoint | Required params |
|-------------|-------------------------|-----------------|
| `backlinks(domain:, **opts)` | `GET /api/v1/backlinks` | `domain` |
| `domain_emails(domain:, **opts)` | `GET /api/v1/domain_emails` | `domain` |
| `domain_infos(domain:)` | `GET /api/v1/domain_infos` | `domain` |
| `keywords_search_volume(keywords:, **opts)` | `GET /api/v1/keywords_search_volume` | `keywords` (Array) |
| `keywords_suggestions(url: nil, keywords: nil, **opts)` | `GET /api/v1/keywords_suggestions` | one of `url` or `keywords` |
| `long_tail_keywords_generator(keyword:, **opts)` | `GET /api/v1/long_tail_keywords_generator` | `keyword` |
| `page_indexation(domain:, keyword:)` | `GET /api/v1/page_indexation` | `domain`, `keyword` |
| `ranking(keyword:, domain:, **opts)` | `GET /api/v1/ranking` | `keyword`, `domain` |
| `scrape(url:)` | `GET /api/v1/scrape` | `url` |
| `scrape_domain(domain:, **opts)` | `GET /api/v1/scrape_domain` | `domain` |
| `scrape_js(url:, js_script: nil)` | `POST /api/v1/scrape_js` | `url` |
| `scrape_js_with_proxy(url:, country:, js_script: nil)` | `POST /api/v1/scrape_js_with_proxy` | `url`, `country` |
| `serp(query:, **opts)` | `GET /api/v1/serp` | `query` |
| `serp_ai_mode(query:, **opts)` | `GET /api/v1/serp_ai_mode` | `query` |
| `serp_html(query:, **opts)` | `GET /api/v1/serp_html` | `query` |
| `serp_js(query:, **opts)` | `GET /api/v1/serp_js` | `query` |
| `serp_js_content(uuid:)` | `GET /api/v1/serp_js/{uuid}` | `uuid` |
| `serp_text(query:, **opts)` | `GET /api/v1/serp_text` | `query` |
| `user` | `GET /api/v1/user` | – |
| `web_page_ai_analysis(url:, prompt:)` | `GET /api/v1/web_page_ai_analysis` | `url`, `prompt` |
| `web_page_seo_analysis(url:)` | `GET /api/v1/web_page_seo_analysis` | `url` |

### Example — Get keyword suggestions

```ruby
client = FetchSERP.new(api_key: ENV["FETCHSERP_API_KEY"])

resp = client.keywords_suggestions(keywords: ["ruby sdk", "seo api"], country: "us")
puts resp.data["keywords_suggestions"]
```

### Example — Get SERP AI Overview and AI Mode

```ruby
client = FetchSERP.new(api_key: ENV["FETCHSERP_API_KEY"])

# Get AI overview and AI mode response for a search query
resp = client.serp_ai_mode(query: "ruby programming best practices")
```

### Handling errors

Any 4xx/5xx response raises `FetchSERP::Error` which includes `status` and raw `body` so you can debug:

```ruby
begin
  client.serp(query: "ruby openai")
rescue FetchSERP::Error => e
  warn "Error #{e.status}: #{e.body}"
end
```

## Contributing

Bug reports and pull requests are welcome!

## License

GPL-3.0 