class ApplicationController < ActionController::API
  include JwtAuthenticatable
  include ErrorHandler
end
