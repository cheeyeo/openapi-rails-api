Rswag::Ui.configure do |c|

  # List the Swagger endpoints that you want to be documented through the swagger-ui
  # The first parameter is the path (absolute or relative to the UI host) to the corresponding
  # JSON endpoint and the second is a title that will be displayed in the document selector
  # NOTE: If you're using rspec-api to expose Swagger files (under swagger_root) as JSON endpoints,
  # then the list below should correspond to the relative paths for those endpoints

  c.swagger_endpoint '/api-docs/v1/swagger.json', 'API V1 Docs'
  c.oauth_config_object = {
    clientId: Rails.application.credentials.oauth[:swagger][:client_id],
    clientSecret: Rails.application.credentials.oauth[:swagger][:client_secret],
    additionalQueryStringParams: {
      # redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
      redirect_uri: 'http://localhost:3000/oauth-redirect',
      username: 'noop@swagger.com',
      response_type: 'code'
    }
  }
end
