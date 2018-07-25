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
end
