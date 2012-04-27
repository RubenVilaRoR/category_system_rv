require 'spec_helper'

describe Admin::HomeController do
  before(:each) do
    admin = FactoryGirl.create(:admin)
    login_user(admin)
  end
  
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should redirect_to(categories_path)
    end
  end

end
