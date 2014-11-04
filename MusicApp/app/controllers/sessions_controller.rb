class SessionsController < ApplicationController
  before_action :require_logged_in
  
  def new
    render :new
  end
  
  def create
    login_user!
    @user = User.find_by(session_token: session[:session_token])
    redirect_to user_url
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end
  
 
  
end
