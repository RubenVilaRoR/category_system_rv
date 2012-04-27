require 'spec_helper'

describe "Activities" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @organization = @user.organization
    @category = FactoryGirl.create(:category, organization: @organization)
    login_user_post(@user.username, 'secret')
  end

  describe "Create new Activity" do
    describe "with valid parameter" do
      it "create a new activity" do
        visit categories_path
        click_link @category.name
        click_link "Add Activity"
        select @category.name, from: 'Category'
        select_date '2012-03-01', from: "activity_date"
        fill_in "Info", with: "Information about the activity"
        fill_in "Tags", with: "tag1, tag2, tag3"

        path = File.join(Rails.root, "Rakefile") 
        attach_file("Attachment", path)

        click_button "Create Activity"

        page.should have_content("Activity was successfully created.")        
      end
    end
    
    describe "without valid parameter" do
      before(:each) do
        visit new_activity_path()
        select @category.name, from: 'Category'
        select_date '2012-03-01', from: "activity_date"
        fill_in "Info", with: "Information about the activity"
        fill_in "Tags", with: "tag1, tag2, tag3"
      end

      it "should not create activity without information" do
        select '', from: 'Category'
        click_button "Create Activity"

        page.should have_content("can't be blank")
      end      
          
      it "should not create activity without information" do
        fill_in "Info", with: ""
        click_button "Create Activity"

        page.should have_content("Infocan't be blank")
      end      
    end
  end
  
  describe "View detail activity" do
    it "show activity detail" do
      @activity = FactoryGirl.create(:activity, category: @category, user: @user, date: '2012-03-01', info: 'Info test', tags: 'Tag1, Tag2', organization: @user.organization)
      visit categories_path
      click_link @category.name
      click_link "Detail"
      
      page.should have_content("Thursday March 01, 2012")
      page.should have_content("Info test")
      page.should have_content("Tag1, Tag2")
      page.should have_content("#{@user.name} (#{@user.username})")
    end
  end
  
  describe "Update activity" do
    before(:each) do
      @activity = FactoryGirl.create(:activity, category: @category, user: @user, date: '2012-03-01', info: 'Info test', tags: 'Tag1, Tag2', organization: @user.organization)
    end
    
    describe "with valid parameter" do
      it "update the activity" do
        visit categories_path
        click_link @category.name
        click_link "Edit"
        
        select_date '2012-03-02', from: 'activity_date'
        fill_in "Info", with: "Info test edit"
        fill_in "Tags", with: "Tag1 edit, Tag2 edit"
        click_button "Update Activity"

        page.should have_content("Friday March 02, 2012")
        page.should have_content("Info test edit")
        page.should have_content("Tag1 edit, Tag2 edit")
        page.should have_content("#{@user.name} (#{@user.username})")
      end
    end
    
    describe "without valid parameter" do
      before(:each) do
        visit categories_path
        click_link @category.name
        click_link "Edit"
      end
      
      it "should not update activity without info" do
        fill_in "Info", with: ''
        click_button "Update Activity"
        
        page.should have_content("Infocan't be blank")
      end
    end    
  end
  
  describe "Delete activity" do
    it "should delete activity" do
      @activity = FactoryGirl.create(:activity, category: @category, user: @user, date: '2012-03-01', info: 'Info test', tags: 'Tag1, Tag2', organization: @user.organization)
      
      expect {
        visit categories_path
        click_link @category.name
        click_link "Delete"
      }.to change(Activity, :count).by(-1)
    end
  end
  
  describe "Search Activities" do
    before(:each) do
      @activity1 = FactoryGirl.create(:activity, category: @category, user: @user, date: '2012-03-01', info: 'lorem ipsum dolor sit amet', tags: 'Tag1, Tag2', organization: @user.organization, priority: 1 )
      @activity2 = FactoryGirl.create(:activity, category: @category, user: @user, date: '2012-03-01', info: 'dolor sit amet const', tags: 'Tag1, Tag2', organization: @user.organization, priority: 2)      
    end
    
    it "should display matched activity info" do      
      visit search_activities_path
      fill_in "q[info_or_tags_cont]", with: "dolor"
      click_button 'Search'
      
      page.should have_content("lorem ipsum dolor sit amet")
      page.should have_content("dolor sit amet const")
    end
    
    it "should display matched activity priority", js: true do      
      visit search_activities_path
      click_link "advance"
      fill_in "q[priority_cont]", with: "1"
      click_button 'Search'

      page.should have_content("lorem ipsum dolor sit amet")
      page.should_not have_content("dolor sit amet const")      
    end
    
    it "should display matched activity category", js: true do      
      visit search_activities_path
      click_link "advance"
      fill_in "q[category_name_cont]", with: @category.name
      click_button 'Search'

      page.should have_content("lorem ipsum dolor sit amet")
      page.should have_content("dolor sit amet const")      
    end
    
  end
end
