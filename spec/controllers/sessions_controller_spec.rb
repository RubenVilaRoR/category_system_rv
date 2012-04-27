require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end
  
  describe "with login" do
    before(:each) do
      @username = "tester"
      @password = "secret"        
    end
    
    describe "user active" do      
      describe "ordinary user" do
        it "should redirect to root path" do
          @user = FactoryGirl.create(:user, username: @username, password: @password, password_confirmation: @password)
          post 'create', { username: @username, password: @password }
          assigns(:user).should eq(@user)
          response.should redirect_to(categories_path)
        end
        
        it "should display user not active and re render new " do
          @user = FactoryGirl.create(:user, username: @username, password: @password, password_confirmation: @password, active: false)
          post 'create', { username: @username, password: @password }
          flash[:error].should eq("User are not active")
          response.should render_template("new")
          response.should_not redirect_to(root_path)
        end
        
        it "should display that user or password not match and rerender form" do
          @user = FactoryGirl.create(:user, username: @username, password: @password, password_confirmation: @password)
          post 'create', { username: @username, password: 'foo' }
          flash[:error].should eq("Username or Password was invalid")
          response.should render_template("new")
          response.should_not redirect_to(root_path)
        end
      end
      
      describe "admin" do
        it "should redirect to admin root path" do
          @user = FactoryGirl.create(:admin, username: @username, password: @password, password_confirmation: @password)
          post 'create', { username: @username, password: @password }
          assigns(:user).should eq(@user)
          response.should redirect_to(categories_path)
        end
      end
    end
  end
  
  describe "destroy" do
    it "should assing current_user with nil" do
      @user = FactoryGirl.create(:user)
      login_user(@user)
      delete :destroy
      @controller.current_user.should be_false
    end
    
  end

end
