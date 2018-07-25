class CustomAuthorizationsController < Doorkeeper::AuthorizationsController
  private

  def redirect_or_render(auth)
    if auth.redirectable?
      if Doorkeeper.configuration.api_only
        if request.env['HTTP_REFERER'] =~ /api-docs/i
          redirect_to auth.redirect_uri
        else
          render(
            json: { status: :redirect, redirect_uri: auth.redirect_uri },
            status: auth.status
          )
        end
      else
        redirect_to auth.redirect_uri
      end
    else
      render json: auth.body, status: auth.status
    end
  end
end
