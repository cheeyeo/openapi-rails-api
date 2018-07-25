class CustomTokensController < Doorkeeper::TokensController
  def create
    # TODO: Need to scope below to be for /api-docs/ only
    if request.env['HTTP_REFERER'] =~ /api-docs/i
      Rails.logger.debug('Found call from Swagger!')
      tmp = params['code'].split('&')
      tmp_code = tmp.first
      tmp_state = tmp.last.gsub('state=', '')

      params[:code] = tmp_code
      params[:state] = tmp_state

      clear_access_token
    end

    response = authorize_response
    headers.merge! response.headers
    self.response_body = response.body.to_json
    self.status = response.status
  rescue ActiveRecord::RecordInvalid => err
    if err.message =~ /Token has already been taken/i
      Rails.logger.debug('Found existing token!!!')
    end

    handle_token_exception err
  rescue Doorkeeper::Errors::DoorkeeperError => e
    handle_token_exception e
  end

  # clear_access_token deletes the AccessToken if it exists so the Swagger UI
  # can re-generate it after a refresh; the UI does not store the token
  def clear_access_token
    user = User.where(email: 'noop@swagger.com').first

    generated_jwt = Doorkeeper::JWT.generate(
      resource_owner_id: user.id,
      application: {
        uid: Rails.application.credentials.oauth[:swagger][:client_id]
      }
    )

    access_token = Doorkeeper::AccessToken.where(token: generated_jwt).first
    Rails.logger.debug("FOUND ANY EXISTING ACCESS TOKEN: #{access_token.inspect}")

    access_token.destroy! if access_token.present?
  end
end
