class UsersController < ApplicationController
  
  def create
    user = User.new(user_params)
    
    if user.save
      login_user!
      render json: user
    else
      render :new
    end
  end
  
  def new
    render :new
  end
  
  private
  def user_params
    params.require(:user)
    .permit(:email, :password_digest, :session_token, :password)
  end
end