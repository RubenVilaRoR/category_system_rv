require 'spec_helper'

describe UsersController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end
  
  describe "POST 'create" do    
    it "should create a user with valid parameter" do
      post :create, user: { username: 'user2', name: 'user2', password: 'secret', password_confirmation: 'secret'  , email: 'user@test.com', organization_name: 'Pivotal'}
      
      user = User.find_by_username('user2')
      user.should_not be_nil
      user.organization.should_not be_nil
      user.organization.name.should eq('Pivotal')
    end
    
    it "should not save without organization_name" do
      post :create, user: { username: 'user2', name: 'user2', password: 'secret', password_confirmation: 'secret'  , email: 'user@test.com', organization_name: ''}
      
      user = User.find_by_username('user2')
      user.should be_nil
      
      response.should_not redirect_to(login_path)
    end
    
    it "should not mass asign admin" do
      expect do
        post :create, user: { username: 'user2', name: 'user2', password: 'secret', password_confirmation: 'secret'  , admin: 1, emai: 'user@test.com'}
      end.to raise_error
    end
    
    it "should not mass asign organization" do
      expect {
        post :create, user: { username: 'user2', name: 'user2', password: 'secret', password_confirmation: 'secret'  , email: 'user@test.com', organization: {id: 10}}
      }.to raise_error
    end
  end
  
  describe "GET edit" do
    it 'should assign user' do
      user = FactoryGirl.create(:user)
      login_user(user)
      get :edit, id: user
      assigns(:user).should eq(user)
    end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      login_user(@user)
    end
    
    describe "with correct parameter" do
      it 'should update the user information' do    
        put :update, id: @user, user: { username: 'user2e', name: 'user2e', password: 'secret1', password_confirmation: 'secret1'}
        @user.reload
        @user.username.should eq('user2e')
        @user.name.should eq('user2e')
      end
    end
    
    describe "With mass asignment" do
      it "should not mass asign admin property" do
        lambda do
          put :update, id: @user, user: { username: 'user2e', name: 'user2e', password: 'secret1', password_confirmation: 'secret1', admin: 1}          
        end.should raise_error
      end
    end
  end
  
end
