class ApplicationController < ActionController::API
  include JwtAuthenticatable
  include ErrorHandler
  include Pundit::Authorization

  before_action :authorize_request

  def authorize_request
    @current_user = AuthorizeRequest.new(headers: request.headers).call
  end
  def current_user
    @current_user || nil
  end
end
