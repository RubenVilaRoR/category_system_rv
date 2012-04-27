require 'spec_helper'

describe "Folders" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_user_post(@user.username, 'secret')
    
    @folder1 = FactoryGirl.create(:folder, name: 'Folder1', organization: @user.organization)
    @folder2 = FactoryGirl.create(:folder, name: 'Folder2') 
  end
  
  describe "List folder" do
    it "display category in list" do
      visit folders_path
    
      page.should have_content("Folder1")
      page.should_not have_content("Folder2")
    end
  end
  
  describe "Create new folder" do
    describe "with valid parameter" do
      it "should save folder" do
        visit new_folder_path

        fill_in :name, with: 'Folder 3'
        click_button "Create Folder"
        page.should have_content("Folder was successfully created")
        page.should have_content("Folder 3")
      end      
    end
    
    describe "with invalid parameter" do
      it "should display error message" do
        visit new_folder_path

        fill_in :name, with: ''
        click_button "Create Folder"
        page.should have_content("Some errors were found, please take a look")
        page.should have_content("Namecan't be blank")        
      end
    end
  end
  
  describe "Edit a folder" do
    describe "with valid parameter" do
      it "should update a folder" do
        visit edit_folder_path(@folder1)

        fill_in :name, with: 'Folder 1 edit'
        click_button "Update Folder"
        page.should have_content("Folder was successfully updated")
        page.should have_content("Folder 1 edit") 
      end      
    end
    
    describe "with invalid parameter" do
      it "should display error message" do
        visit new_folder_path

        fill_in :name, with: ''
        click_button "Create Folder"
        page.should have_content("Some errors were found, please take a look")
        page.should have_content("Namecan't be blank")        
      end
    end
  end
end
