class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :login_user!, :current_user, :logged_in?, :require_logged_in
  
  def login_user!
    user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password])
    if user
      session[:session_token] = user.reset_session_token!
    else
      nil
    end
  end
  
  def current_user
    return if session[:session_token].nil?
    User.find_by(:session_token => session[:session_token])
  end
  
  def logged_in?
    return true if User.find_by(:session_token => session[:session_token])
    false
  end
  
  def require_logged_in
    redirect_to new_user_url unless logged_in?
  end
end
