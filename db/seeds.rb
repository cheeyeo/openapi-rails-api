# Create swagger application mode
# redirect-uri must match value in config/initializers/rswag-ui.rb
# Need to also update the Rails.application.credentials.oauth swagger
# blocks with the uid and secret with values from created model below
uri = Rails.application.routes.default_url_options[:host]
Doorkeeper::Application.create!(
  name: 'Swagger UI',
  redirect_uri:  uri + '/oauth-redirect'
)

User.create!(
  name: 'Swagger UI',
  email: 'noop@swagger.com',
  password: 'password',
  password_confirmation: 'password'
)
