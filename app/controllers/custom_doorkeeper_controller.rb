class CustomDoorkeeperController < ApplicationController
  # TODO: Below does not work as the inheritance chain does not bubble up??
  # But we can rescue it from the oauth client itself
  rescue_from ActiveRecord::RecordInvalid, with:
    :render_unprocessable_entity_response

  def render_unprocessable_entity_response(exception)
    puts "INSIDE CUSTOM RECORDINVALID BLOCK!!!"
    render json: {
      errors: ValidationErrorsSerializer.new(exception.record).serialize
    }, status: :unprocessable_entity
  end
end
