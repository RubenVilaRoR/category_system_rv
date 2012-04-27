class HomeController < ApplicationController
  before_filter :authorize
  def index
    redirect_to categories_path 
  end
end
