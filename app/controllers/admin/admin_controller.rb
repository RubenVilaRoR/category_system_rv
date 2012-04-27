class Admin::AdminController < ApplicationController
  before_filter :authorize
  
  def authorize
    if current_user
      unless current_user.admin?
        flash[:error]= 'access denied'
        redirect_to root_path
      end
    else
      flash[:error]= 'Please login first'
      redirect_to login_path
    end
  end
end
