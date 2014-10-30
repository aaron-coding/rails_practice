class SessionsController < ApplicationController
  
  def new
    render :new
  end
  
  def create
    login_user!
    redirect_to "/"
  end
  
 
  
end
