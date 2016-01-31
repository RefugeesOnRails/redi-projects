class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_user
    token = request.headers['Auth-Token']
    user = User.find_authenticated_user(token)
    if user then
      @current_user = user
    else
      response = {
        success: false,
        description: "Not authenticated"
      }
      render json: response.to_json, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
