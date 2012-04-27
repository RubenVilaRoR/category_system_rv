require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    describe "wihtout login" do
      it "returns redirect to login" do
        get 'index'
        response.status.should eq(302)
      end      
    end
    
    describe "with login" do
      it "return success" do
        @user = FactoryGirl.create(:user)
        login_user(@user)
        get 'index'
        response.should redirect_to(categories_path)
      end
    end
  end

end
