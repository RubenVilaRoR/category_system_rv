require 'spec_helper'

describe Category do
  describe "with valid parameter" do
    it "should persist to database" do
      FactoryGirl.create(:category)
    end
  end
  
  describe "without valid parameter" do
    it "should not save without name" do
      category = FactoryGirl.build(:category, name: nil)
      category.save.should be_false
    end
    
    it "should now save without organization" do
      category = FactoryGirl.build(:category, organization: nil)
      category.save.should be_false
    end
    
    it "should not save with color more than 7 characters" do
      category = FactoryGirl.build(:category, color: '12345678')
      category.save.should be_false
    end
  end
  
  describe "name_should_be_unique_per_organization" do
    describe "with the same organization" do
      before(:each) do
        @category = FactoryGirl.create(:category, name: 'cat1')        
      end
      
      it "should not add errors if it's the current model" do
        @category.name = 'cat1'
        @category.save.should be_true
      end
      
      it "should add errors if the the existing name exitst" do
        category = FactoryGirl.build(:category, name:'cat1', organization: @category.organization)
        category.save.should be_false
      end
    end
    
    describe "with different organization" do
      it "should save to database" do
        category = FactoryGirl.build(:category, name:'cat1')
        category.save.should be_true
      end
    end
  end
  
  describe "check_permission" do
    it "should return true if category use_privacy is false" do
      category = FactoryGirl.build(:category, use_privacy: false)
      user = FactoryGirl.build(:user)
      category.check_permission(user).should be_true
    end
    
    describe "if use_privacy is true" do
      before(:each) do
        @category = FactoryGirl.build(:category, use_privacy: true)
      end
      
      it "should return true if user is admin" do  
        user = FactoryGirl.build(:user, admin: true, organization: @category.organization)
        @category.check_permission(user).should be_true      
      end
      
      describe "user have no permission to the category" do
        it "should return false" do
          user = FactoryGirl.create(:user, admin: false)
          category = FactoryGirl.create(:category, use_privacy: true, users: [])
          category.check_permission(user).should be_false          
        end
      end
      
      describe "user have permission to the category" do
        it "shoudl return true" do
          user = FactoryGirl.create(:user, admin: false)
          category = FactoryGirl.create(:category, use_privacy: true, users: [user])
          category.check_permission(user).should be_true
        end
      end
    end
  end
end
