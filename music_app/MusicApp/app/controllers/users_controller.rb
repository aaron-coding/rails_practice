class UsersController < ApplicationController
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      login_user!
      redirect_to user_url
    else
      render :new
    end
  end
  
  def new
    render :new
  end
  
   def show
     @user = User.find_by(session_token: session[:session_token])
     render :show
   end
  
  private
  
  def user_params
    params.require(:user)
    .permit(:email, :password_digest, :session_token, :password)
  end
end