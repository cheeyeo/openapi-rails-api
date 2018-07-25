require 'oauth2'

module Rack
  class Swagger
    def initialize(app)
      @app = app
    end

    def call(env)
      req = ActionDispatch::Request.new env
      puts "PATH: #{req.path.inspect}"
      puts "REQ PARAMS: #{req.params.inspect}"
      puts "URI: #{req.env['REQUEST_URI']}"

      if req.env['HTTP_REFERER'] =~ /api-docs/i && req.env['REQUEST_METHOD'] == 'GET' && req.params.has_key?('state')
        Rails.logger.debug 'Inside set token for swagger'

        client = oauth_client("http://#{req.env['HTTP_HOST']}")

        tokenurl = client.auth_code.authorize_url(
          redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
          username: 'noop@swagger.com'
        )

        # Get the Authentication token by visiting the token url
        data = Net::HTTP.get(URI(tokenurl))
        res = JSON.parse(data)
        code = res['redirect_uri']['code']

        # Exchange for authentication token
        bearer = client.auth_code.get_token(code, redirect_uri: 'urn:ietf:wg:oauth:2.0:oob')

        headers = ActionDispatch::Http::Headers.from_hash(env)
        headers['Authorization'] = "Bearer #{bearer.token}"
      end

      #byebug
      puts req.headers['Authorization'].inspect

      @app.call(env)
    end

    def client_id
      @clientid ||= Rails.application.credentials.oauth[:swagger][:client_id]
    end

    def client_secret
      @clientsecret ||= Rails.application.credentials.oauth[:swagger][:client_secret]
    end

    def oauth_client(host)
      Rails.logger.debug("OAUTH CLIENT: HOST: #{host}")
      #OAuth2::Client.new(client_id, client_secret, site: host)
      @client ||= OAuth2::Client.new(client_id, client_secret, site: host)
    end
  end
end
