require 'oauth/request_proxy/base'

module Smugsyncv2
  class Client
    TOKEN_FILE = '.token_cache'

    def initialize(key, secret, logger = false)
      @uris = nil
      @key = key
      @secret = secret
      @logger = logger
    end

    def oauth_opts
      { site: OAUTH_ORIGIN,
        request_token_path: REQUEST_TOKEN_PATH,
        access_token_path: ACCESS_TOKEN_PATH,
        authorize_path: AUTHORIZE_PATH
      }
    end

    def login # rubocop:disable Metrics/MethodLength
      @consumer = OAuth::Consumer.new(@key, @secret, oauth_opts)
      return load_cached_token if File.exist?(TOKEN_FILE)
      @request_token = @consumer.get_request_token
      authorize_url = @request_token.authorize_url + '&Access=Full'
      puts "Open a web browser and open: #{authorize_url}"
      puts 'Enter the validation code: '
      verification_code = STDIN.gets.chomp
      @access_token = @request_token.get_access_token(
      oauth_verifier: verification_code)
      cache_token(@access_token)
      @access_token
    end

    def access_token
      @access_token ||= login
    end

    def consumer
      if @consumer
        @consumer
      else
        login
        @consumer
      end
    end

    def load_cached_token
      Marshal.load(File.open(TOKEN_FILE, 'r'))
    end

    def cache_token(token)
      File.open(TOKEN_FILE, 'w') do |file|
        file.write Marshal.dump(token)
      end
    end

    def adapter(url: BASE_URL)
      @connection = Faraday.new(url: url) do |conn|
        conn.request :json
        conn.response :json
        conn.adapter Faraday.default_adapter
        conn.response :logger if @logger
      end
    end

    def connection(**args)
      @connection ||= adapter(**args)
    end

    def get_oauth_header(method, url, params)
      SimpleOAuth::Header.new(
      method, url,
      params,
      consumer_key: @key,
      consumer_secret: @secret,
      token: access_token.token,
      token_secret: access_token.secret,
      version: '1.0').to_s
    end

    def request(method: :get, path: nil, params: {}, body: nil, headers: {})
      url = path.nil? ? BASE_URL : File.join(API_ORIGIN, path)
      base_headers = { 'User-Agent' => USER_AGENT, 'Accept' => 'application/json' }
      headers = base_headers.merge(headers || {})

      adapter(url: url)
      response = @connection.send(method) do |req|
        oauth_header = get_oauth_header(method, url, params)
        req.headers.merge!('Authorization' => oauth_header)

        req.url url
        req.headers.merge!(headers)
        req.params.merge!(params)
        req.body = body
      end
      @response = DeepOpenStruct.load(response.body)
      @uris = @response.Response.Uris
      @response
    end

    def user_uri
      res = request
      uri = res.Response.Uris.AuthUser.Uri
      user = request(path: uri)
      user = user.Response.User
      user.Uri
    end

    def get_uri(name, uris = @uris)
      uri = uris.send(name).Uri
      request(path: uri)
      if @response && @response.Response && @response.Response.send(name)
        @uris = @response['Response'][name]['Uris']
      end
      @response
    end
  end
end
