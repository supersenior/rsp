class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception,
                       unless: :api_request?

  helper_method :current_user, :true_user

private

  def current_user
    @current_user ||= User.find(session[:impersonated_user_id]) if session[:impersonated_user_id]
    @current_user ||= true_user
  end

  def true_user
    if api_request?
      @true_user ||= User.find_by(email: 'api@watchtowerbenefits.com')
    elsif session[:user_id]
      @true_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

  def authenticate_user!
    unless current_user
      store_location

      redirect_to log_in_path, flash: { error: "You must be logged in before you do this." }
    end
  end

  def authenticate_admin!
    unless true_user.try(:is_admin?)
      store_location

      redirect_to :back, flash: { error: "You do not have the correct permissions to do this." }
    end

  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def store_location
    session[:return_url] = request.url
  end

  def api_request?
    request.headers['X-API-AUTHTOKEN'] == Rails.application.secrets.api_token
  end
end
