require 'spec_helper'

describe Folder do
  describe "with valid attribute" do
    it "should save" do
      FactoryGirl.create(:folder).should be_persisted
    end
  end
  
  describe "with invalid attribute" do
    it "should not save without name" do
      folder = FactoryGirl.build(:folder, name: nil)
      folder.save.should be_false
    end
    
    it "should not save without organization" do
      folder = FactoryGirl.build(:folder, organization: nil)
      folder.save.should be_false      
    end
  end
  
  describe "with duplicate name" do
    describe "on same organization" do
      it "should not save" do
        organization = FactoryGirl.create(:organization)
        folder1 = FactoryGirl.create(:folder, name: 'folder1', organization: organization)
        folder2 = FactoryGirl.build(:folder, name: 'folder1', organization: organization)
        folder2.save.should be_false
      end
    end
    
    describe "on different organization" do
      it "shuld not save to database" do
        folder1 = FactoryGirl.create(:folder, name: 'folder1')
        folder2 = FactoryGirl.build(:folder, name: 'folder1')
        folder2.save.should be_true        
      end
    end
  end
  
  describe "check_permission" do
    describe "user admin" do
      it "should return true" do
        user = FactoryGirl.create(:user, admin:true)
        folder = FactoryGirl.create(:folder, organization: user.organization, use_privacy: true)
        folder.check_permission(user).should be_true
      end
    end
    
    describe "user is not admin" do
      describe "folder privacy is false" do
        it "should return true on folder " do
          user = FactoryGirl.create(:user, admin:true)
          folder = FactoryGirl.create(:folder, organization: user.organization, use_privacy: false)
          folder.check_permission(user).should be_true          
        end
      end
      
      describe "folder privacy is true" do
        it "should return user belong to the folders user" do
          user = FactoryGirl.create(:user)
          user2 = FactoryGirl.create(:user)
          folder = FactoryGirl.create(:folder, organization: user.organization, use_privacy: true, users: [user])
          folder.check_permission(user).should be_true
          folder.check_permission(user2).should be_false
        end
      end
    end
  end
end
