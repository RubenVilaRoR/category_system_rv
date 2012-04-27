class Admin::HomeController < Admin::AdminController
  def index
    redirect_to categories_path 
  end
end
