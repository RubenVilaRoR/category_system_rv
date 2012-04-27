class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authorize
    redirect_to login_url, alert: "Please log in first!" unless current_user 
  end
end
