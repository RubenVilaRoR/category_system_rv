require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "with valid parameter" do
      it "register the user" do
        visit signup_path
        fill_in "Username", with: 'user1'
        fill_in "Name", with: 'user1'
        fill_in "Email", with: 'user@email.com'
        fill_in "Password", with: 'secret'
        fill_in "Password confirmation", with: 'secret'
        fill_in "Organization name", with: 'My Organization'
        click_button "Create User"
        
        page.should have_content('Sucessfully signed up!')
      end
    end
    
    describe "without valid parameter" do
      before(:each) do        
        visit signup_path
        fill_in "Username", with: 'user1'
        fill_in "Name", with: 'user1'
        fill_in "Email", with: 'user@email.com'
        fill_in "Password", with: 'secret'
        fill_in "Password confirmation", with: 'secret'
        fill_in "Organization name", with: 'My Organization'        
      end
      
      it "does not resiter the user with no username" do
        fill_in "Username", with: ''
        page.should_not have_content('Sucessfully signed up!')
      end
      
      it "does not resiter the user with no name" do
        visit signup_path
        fill_in "Name", with: 'user1'
        page.should_not have_content('Sucessfully signed up!')
      end
      
      it "does not resiter the user with un match password" do
        fill_in "Password", with: ''
        page.should_not have_content('Sucessfully signed up!')
      end
      
      it "does not resiter the user with no organization" do
        fill_in "Organization name", with: ''
        page.should_not have_content('Sucessfully signed up!')
      end
      
    end
  end
  
  describe "signin" do
    before(:each) do
      user = FactoryGirl.create(:user, username: 'johny', password: 'secret', password_confirmation: 'secret', email: 'johny@test.com')
    end
    
    it "should sign the user in with the correct password" do
      visit login_path
      fill_in "Username", with: 'johny'
      fill_in "Password", with: 'secret'
      click_button "Log in"      
      
      page.should have_content('Logged in!')      
    end
    
    it "should not sign in the user with incorrect password" do
      visit login_path
      fill_in "Username", with: 'johny'
      fill_in "Password", with: 'false'
      click_button "Log in"
            
      page.should have_content('Username or Password was invalid')
    end
    
    it "should not sign in the user with incorrect username" do
      visit login_path
      fill_in "Username", with: 'johny1'
      fill_in "Password", with: 'secret'
      click_button "Log in"
            
      page.should have_content('Username or Password was invalid')
    end    
  end
  
  describe "Edit user information" do
    before(:each) do
      @user = FactoryGirl.create(:user, username: 'johny', password: 'secret', password_confirmation: 'secret', email: 'johny@test.com') 
      login_user_post('johny', 'secret')
      visit account_path
    end
    
    describe "with valid parameter" do
      it "Should change user information without password change" do
        fill_in "Username", with: "username1"
        fill_in "Name", with: "New name"
        fill_in "Email", with: "anymail@mail.com"
        click_button "Update User"

        @user.reload
        @user.username.should eq("username1")
        @user.name.should eq("New name")
        @user.email.should eq("anymail@mail.com")
      end
    end  
    
    describe "with invalid parameter" do
      it "should not save user without username" do
        fill_in "Username", with: ""
        click_button "Update User"
        page.should have_content("Usernamecan't be blank")
      end
      
      it "should not save user without name" do
        fill_in "Name", with: ""
        click_button "Update User"
        page.should have_content("Namecan't be blank")
      end
      
      it "should not save user without email" do
        fill_in "Email", with: ""
        click_button "Update User"
        page.should have_content("Emailcan't be blank")
      end
      
      it "should not save user with password less then 5 character" do
        fill_in "Password", with: "foo"
        fill_in "Password confirmation", with: "foo"
        click_button "Update User"
        page.should have_content("Passwordis too short (minimum is 5 characters)")                
      end
      
      it "should not save user with unmatch password" do
        fill_in "Password", with: "12345"
        fill_in "Password confirmation", with: "54321"
        click_button "Update User"
        page.should have_content("Passworddoesn't match confirmation")        

      end
    end  
  end
end