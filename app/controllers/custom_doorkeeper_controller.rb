class CustomDoorkeeperController < ApplicationController
  # Issue: CustomTokensController inherits from Doorkeeper::ApplicationMetalController
  # which means it will not call below

  rescue_from ActiveRecord::RecordInvalid, with:
    :render_unprocessable_entity_response

  def render_unprocessable_entity_response(exception)
    render json: {
      errors: ValidationErrorsSerializer.new(exception.record).serialize
    }, status: :unprocessable_entity
  end
end
