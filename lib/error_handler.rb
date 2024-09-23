module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from StandardError, with: :handle_standard_error
  end

  private

  def handle_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def handle_record_invalid(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_standard_error(exception)
    render json: { error: exception.message }, status: :internal_server_error
  end
end