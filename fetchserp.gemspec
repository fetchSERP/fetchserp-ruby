Gem::Specification.new do |spec|
  spec.name          = "fetchserp"
  spec.version       = "0.1.0"
  spec.authors       = ["FetchSERP"]
  spec.email         = ["contact@fetchserp.com"]

  spec.summary       = "Ruby SDK for the FetchSERP REST API"
  spec.description   = "A lightweight Ruby client for interacting with the FetchSERP API. Provides helpers for authentication and convenient Ruby methods for each endpoint."
  spec.homepage      = "https://github.com/fetchserp/fetchserp-ruby"
  spec.license       = "GPL-3.0-or-later"

  spec.metadata ||= {}
  spec.metadata["homepage_uri"]     = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "https://github.com/fetchserp/fetchserp-ruby/releases"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.files         = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  # No external runtime dependencies; uses Ruby standard library
end 