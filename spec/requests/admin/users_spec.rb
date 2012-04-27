require 'spec_helper'

describe "Admin user administration" do
  before(:each) do
    @admin = FactoryGirl.create(:admin, username: 'Admin')
    login_user_post('admin', 'secret')
  end
  
  describe "List all user" do
    it "list the users belonging to the organization" do
      visit admin_users_path
      within(:xpath, '//td[1]') { page.should have_content('Admin') }
      within(:xpath, '//td[2]') { page.should have_content('User Name') }
      within(:xpath, '//td[3]') { page.should have_content('Active') }
      within(:xpath, '//td[4]') { page.should have_content('Yes') }
    end
  end
  
  describe "Create new user" do
    before(:each) do
      visit new_admin_user_path
    end

    describe "with valid parameter" do
      it "should create a new user" do
        fill_in "Username", with: 'user1'
        fill_in "Name", with: 'user1'
        fill_in "Email", with: 'user@email.com'
        fill_in "Password", with: 'secret'
        fill_in "Password confirmation", with: 'secret'
        click_button "Create User"

        page.should have_content('Sucessfully signed up!')        
      end
    end
    
    describe "without valid parameter" do
      before(:each) do        
        fill_in "Username", with: 'user1'
        fill_in "Name", with: 'user1'
        fill_in "Email", with: 'user@email.com'
        fill_in "Password", with: 'secret'
        fill_in "Password confirmation", with: 'secret'
      end

      it "does not resiter the user with no username" do
        fill_in "Username", with: ''
        click_button "Create User"
        page.should have_content('Usernamecan\'t be blank')
      end

      it "does not resiter the user with no name" do
        fill_in "Name", with: ''
        click_button "Create User"        
        page.should have_content("Namecan't be blank")
      end

      it "does not resiter the user with un match password" do
        fill_in "Password", with: '123456'
        fill_in "Password", with: '654321'
        click_button "Create User"        
        page.should_not have_content('Sucessfully signed up!')
      end
    end
  end
  
  describe "Update User" do
    before(:each) do
      @user = FactoryGirl.create(:user, organization: @admin.organization)
      visit admin_users_path
      within(:xpath, '//tr[3]') { click_link 'edit'}
    end
    
    describe "Update user information" do
      describe "with valid information" do
        it "will save the user" do
          fill_in "Username", with: 'user1'
          fill_in "Name", with: 'user1'
          fill_in "Email", with: 'user@email.com'
          fill_in "Password", with: 'secret'
          fill_in "Password confirmation", with: 'secret'
          click_button "Update User"

          page.should have_content('Successfully updated user')
        end
      end
      
      describe "with invalid user information" do  
        it "does not resiter the user with no username" do
          fill_in "Username", with: ''
          click_button "Update User"
          page.should have_content('Usernamecan\'t be blank')
        end

        it "does not resiter the user with no name" do
          fill_in "Name", with: ''
          click_button "Update User"        
          page.should have_content("Namecan't be blank")
        end

        it "does not resiter the user with un match password" do
          fill_in "Password", with: '123456'
          fill_in "Password", with: '654321'
          click_button "Update User"        
          page.should_not have_content('Sucessfully signed up!')
        end
      end
    end
  end
  
  describe "Delete user" do
    it "should delete the user" do      
      @user = FactoryGirl.create(:user, organization: @admin.organization)
      visit admin_users_path
      
      expect { within(:xpath, '//tr[3]') { click_link 'delete'} }.to change(User, :count).by(-1)
    end
  end
end