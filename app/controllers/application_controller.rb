class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with:
    :render_unprocessable_entity_response

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  rescue_from ActionController::ParameterMissing, with: :render_empty_params

  def render_empty_params(exception)
    render json: {
      errors: ErrorSerializer.new(:bad_request, exception).serialize
    }, status: :bad_request
  end

  def render_not_found_response(exception)
    render json: {
      errors: ErrorSerializer.new(:not_found, exception).serialize
    }, status: :not_found
  end

  def render_unprocessable_entity_response(exception)
    render json: {
      errors: ValidationErrorsSerializer.new(exception.record).serialize
    }, status: :unprocessable_entity
  end
end
