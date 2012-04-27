# encoding: utf-8

require 'spec_helper'

describe "Categories" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_user_post(@user.username, 'secret')
    
    @category1 = FactoryGirl.create(:category, name: 'Category1', organization: @user.organization, color: '000000')
    @category2 = FactoryGirl.create(:category, name: 'Category2') 
  end
  
  describe "List Categories" do
    it "should only display categories belong to the company" do
      visit categories_path
      page.should have_content("Category1")
      page.should_not have_content("Category2")
    end
  end
  
  describe "Show category" do
    describe "without activity" do
      it "should show category information" do
        visit category_path(@category1)
        within ('#category-info') do 
          page.should have_content("Category1")
        end
      end
      
      it "should show notification of no activity" do
        visit category_path(@category1)
        page.should have_content("There currently no activity in this category")       
      end
    end
  end
  
  describe "Create new category" do
    describe "with valid parameter" do
      it "should create new category" do
        visit new_category_path
        fill_in "Name", with: "Category19"
        click_button "Create Category"
        page.should have_content("Category was successfully created")
        page.should have_content("Category1")
      end
      
      it "should create category even there is existing name but different organization" do
        visit new_category_path
        fill_in "Name", with: "Category2"
        click_button "Create Category"
        page.should have_content("Category was successfully created")
        page.should have_content("Category2")
      end
    end
    
    describe "with invalid parameter" do
      it "shouldnot create category with no name" do
        visit new_category_path
        fill_in "Name", with: ""
        click_button "Create Category"
        page.should have_content("Namecan't be blank")                      
      end
      
      it "should not create existing category" do
        visit new_category_path
        fill_in "Name", with: "Category1"
        click_button "Create Category"
        page.should have_content("Namealready exists")                              
      end
    end
  end
  
  describe "Update existing category" do
    describe "with valid parameter" do
      it "should create new category" do
        visit edit_category_path(@category1)
        fill_in "Name", with: "Category1 edit"
        click_button "Update Category"
        page.should have_content("Category was successfully updated")
        page.should have_content("Category1 edit")
      end
      
      it "should valid if name does not change" do
        visit edit_category_path(@category1)
        click_button "Update Category"
        page.should have_content("Category was successfully updated")        
      end
      
      it "should error if there is existing category in same organization" do
        category = FactoryGirl.create(:category, name: 'Category test', organization: @user.organization)
        visit edit_category_path(@category1)
        fill_in "Name", with: "Category test"
        click_button "Update Category"
        page.should have_content("Namealready exists")                
      end
    end
    
    describe "without valid parameter" do
      it "should raise error if updating other categories organization" do
        expect { visit edit_category_path(@category2) }.to raise_error
      end
    end
  end
  
  describe "Delete existing category" do
    describe "category belonging to the organization" do
      it "delete a category" do
        expect {
          visit categories_path
          click_link @category1.name
          click_link 'delete'
        }.to change(Category, :count).by(-1)        
      end
    end
    
    describe "category beloning to the organization" do
      it "should raise error and does not change Category" do
        expect {
          page.driver.delete(category_path(@category2)) 
        }.to raise_error and change(Category, :count).by(0)        
      end      
    end
  end
  
  describe "Sorting category" do
    before(:each) do
      @category_red = FactoryGirl.create(:category, name: 'Category Red', organization: @user.organization, color: 'ff0000', group: 'Group 2')
      @category_green = FactoryGirl.create(:category, name: 'Category Green', organization: @user.organization, color: '00ff00', group: 'Group 1')
      @category_blue = FactoryGirl.create(:category, name: 'Category Blue', organization: @user.organization, color: '0000ff', group: 'Group3')
      @category1.destroy
    end
    
    describe "order by name" do
      it "should order category by name" do
        visit categories_path
        click_link "Name"
        page.should have_xpath("//div[@id='category-list']//a[1]", text: 'Category Blue')
        page.should have_xpath("//div[@id='category-list']//a[2]", text: 'Category Green')
        page.should have_xpath("//div[@id='category-list']//a[3]", text: 'Category Red')
        
             
        click_link "Name ▲"
        page.should have_xpath("//div[@id='category-list']//a[3]", text: 'Category Blue')
        page.should have_xpath("//div[@id='category-list']//a[2]", text: 'Category Green')
        page.should have_xpath("//div[@id='category-list']//a[1]", text: 'Category Red')
      end
      
      it "should order category by color" do
        visit categories_path
        click_link "Color"
        page.should have_xpath("//div[@id='category-list']//a[1]", text: 'Category Red')
        page.should have_xpath("//div[@id='category-list']//a[2]", text: 'Category Green')
        page.should have_xpath("//div[@id='category-list']//a[3]", text: 'Category Blue')
        
        click_link "Color"        
        page.should have_xpath("//div[@id='category-list']//a[1]", text: 'Category Blue')
        page.should have_xpath("//div[@id='category-list']//a[2]", text: 'Category Green')
        page.should have_xpath("//div[@id='category-list']//a[3]", text: 'Category Red')
      end
      
      it "should order category by group" do
        visit categories_path
        click_link "Group"
        page.should have_xpath("//div[@id='category-list']//a[1]", text: 'Category Green')
        page.should have_xpath("//div[@id='category-list']//a[2]", text: 'Category Red')
        page.should have_xpath("//div[@id='category-list']//a[3]", text: 'Category Blue')
        
        click_link "Group"
        page.should have_xpath("//div[@id='category-list']//a[3]", text: 'Category Green')
        page.should have_xpath("//div[@id='category-list']//a[2]", text: 'Category Red')
        page.should have_xpath("//div[@id='category-list']//a[1]", text: 'Category Blue')
      end
      
    end
  end
  
  describe "Navigating trough folder" do
    before(:each) do
      @folder = FactoryGirl.create(:folder, organization: @user.organization, name: 'Test')
      @category3 = FactoryGirl.create(:category, name: 'Category3', organization: @user.organization, folder: @folder)
    end
    
    it "should only show category within selected folder" do
      visit categories_path

      within('.folders') do
        click_link "Test"
      end

      page.should have_content("Category3")
      page.should_not have_content("Category2")
      page.should_not have_content("Category1")
      
      within('.folders') do
        click_link "All"
      end

      page.should have_content("Category3")
      page.should have_content("Category1")
      page.should_not have_content("Category2")
      
    end
  end
end
