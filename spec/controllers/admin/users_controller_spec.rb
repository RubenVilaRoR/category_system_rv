require 'spec_helper'
require 'pp'

describe Admin::UsersController do
  before(:each) do
    @admin = FactoryGirl.create(:admin)
    login_user(@admin)
  end
  
  describe "GET index" do
    it "assigns all user that associated with user's organization" do
      user = FactoryGirl.create(:user, organization: @admin.organization)
      user_else = FactoryGirl.create(:user)
      get :index, {}
      assigns(:users).include?(user_else).should be_false
      assigns(:users).include?(@admin).should be_true
      assigns(:users).include?(user).should be_true
      assigns(:users).size.should eq(2)
    end
  end
  
  describe "GET new" do
    before(:each) do
      get :new
    end
    
    it "assign @user with new user" do
      assigns(:user).should be_a_new(User)
    end 
    
    it "should set active as default" do
      assigns(:user).active.should be_true
    end   
  end
  
  describe "GET edit" do
    describe "with user does not associated with same organization" do
      it "should raise an error" do
        user = FactoryGirl.create(:user)
        expect { get :edit, {:id => user.to_param} }.to raise_error
      end
    end
    
    describe "with user that belong to the same organization" do
      it "should assign user with the user" do
        user = FactoryGirl.create(:user, organization: @admin.organization)
        get :edit, id: user.to_param
        assigns(:user).should eq(user)
      end
    end
  end
  
  describe "POST 'create" do
    before(:each) do
      post :create, user: { username: 'new_user', name: 'user2', password: 'secret', password_confirmation: 'secret', email: 'user@test.com', admin: 1}      
    end
    
    it "should create new user as admin" do
        user = User.find_by_username('new_user')
        user.should_not be_nil
        user.admin.should be_true
    end
    
    it "should assign the new user organization same as admin" do
      user = User.find_by_username('new_user')
      user.should_not be_nil
      user.organization.should eq(@admin.organization)
    end
  end

  describe "PUT 'update'" do
    describe "with user that does not belong to the same organization" do
      it "should raise an error" do
        user = FactoryGirl.create(:user)
        expect { 
          put :update, {:id => user.to_param, user: {name: 'new_name'}} 
        }.to raise_error
      end
    end
    
    it "should update admin status" do
        admin = FactoryGirl.create(:admin, organization: @admin.organization)
        admin.admin = false
        post :update, user: {admin: 0}, id: admin
        admin.admin.should be_false
    end  
  end
  
  describe "DELETE destroy" do
    describe "with user that does not belong to the same organization" do
      it "should raise an error" do
        user = FactoryGirl.create(:user)
        expect { 
          delete :destroy, {:id => user.to_param} 
        }.to raise_error
      end
    end
    
    describe "with user that belong to the same organization" do      
      it "should reduce the record and redirect to user index" do
        user = FactoryGirl.create(:user, organization: @admin.organization)
        expect {
          delete :destroy, id: user.to_param                  
        }.to change(User, :count).by(-1)
        response.should redirect_to(admin_users_path)
      end
    end
  end
end
