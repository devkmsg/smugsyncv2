require 'smugsyncv2/version'
require 'faraday_middleware'
require 'faraday'
require 'simple_oauth'
require 'deepopenstruct'
require 'oauth'
require 'json'
require 'pp'
require_relative './smugsyncv2/client.rb'

module Smugsyncv2
  OAUTH_ORIGIN = 'https://secure.smugmug.com'
  REQUEST_TOKEN_PATH =  '/services/oauth/1.0a/getRequestToken'
  ACCESS_TOKEN_PATH =  '/services/oauth/1.0a/getAccessToken'
  AUTHORIZE_PATH = '/services/oauth/1.0a/authorize'

  API_ORIGIN = 'https://api.smugmug.com'
  BASE_PATH = 'api/v2'
  BASE_URL = File.join(API_ORIGIN, BASE_PATH)
  USER_AGENT = "Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}) Smugsyncv2/#{Smugsyncv2::VERSION} Faraday/#{Faraday::VERSION}".freeze
end
