class SessionsController < ApplicationController
  def new
    if current_user
      if current_user.admin?
        redirect_to admin_root_path
      else
        redirect_to root_path
      end
    end
  end
  
  def create
    @user = login(params[:username], params[:password], params[:remember_me])
    if @user
      if !@user.active?
       logout
       flash.now[:error] = "User are not active"
       render :new
      else
        redirect_back_or_to categories_url, notice: "Logged in!" 
      end
    else
      flash.now[:error] = "Username or Password was invalid"
      render :new
    end
  end
  
  def destroy
    logout
    redirect_to login_url, notice: "Logged out!"
  end
end
