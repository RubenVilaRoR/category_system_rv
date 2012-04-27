require 'spec_helper'

describe User do
  before(:each) do
    @user = { username: 'usertest', name: 'User Test', password: 'secret', password_confirmation: 'secret', email: 'user@foo.com', organization_name: 'organization_name'}
  end
  
  describe "Create user without valid parameter" do
    it "should not save without password" do
      userh = @user.dup
      userh[:password] = nil
      userh[:password_confirmation] = nil
      user = User.new userh
      user.organization = FactoryGirl.create(:organization)
      user.save.should be_false
    end
    
    it "should not save with unmatch password" do
      userh = @user.dup
      userh[:password] = '123456'
      userh[:password_confirmation] = '654321'
      user = User.new userh
      user.organization = FactoryGirl.create(:organization)
      user.save.should be_false
    end
    
    it "Should not assign property admin and active if not admin" do
      userh = @user.dup
      userh[:admin] = true
      lambda {
        user = User.new userh
        user.organization = FactoryGirl.create(:organization)
        user.save }.should raise_error
    end
    
    it "should not save with password less then 5 character" do
      userh = @user.dup
      userh[:password] = '1234'
      userh[:password_confirmation] = '1234'
      user = User.new userh
      user.organization = FactoryGirl.create(:organization)
      user.save.should be_false      
    end
    
    it "should not save without email" do
      userh = @user.dup
      userh[:email] = nil
      user = User.new userh
      user.organization = FactoryGirl.create(:organization)
      user.save.should be_false
    end
    
    it "should not save without name" do
      userh = @user.dup
      userh[:name] = nil
      user = User.new userh
      user.organization = FactoryGirl.create(:organization)      
      user.save.should be_false
    end
    
    it "should be unique username" do
      userh = @user.dup
      userb = @user.dup
      userb[:email] = "tester@else.com"
      user1 = User.new userh
      user1.organization = FactoryGirl.create(:organization)      
      user1.save.should be_true
      user2 = User.new userb
      user2.organization = FactoryGirl.create(:organization)    
      user2.save.should be_false
    end
    
    it "should be unique email" do
      userh = @user.dup
      userb = @user.dup
      userb[:username] = "others"
      user1 = User.new userh
      user1.organization = FactoryGirl.create(:organization)      
      user1.save.should be_true
      user2 = User.new userb
      user2.organization = FactoryGirl.create(:organization)      
      user2.save.should be_false
    end
    
    it "should not save when username is lessthen 5 character" do
      userh = @user.dup
      userh[:username] = '1234'
      user = User.new userh
      user.organization = FactoryGirl.create(:organization)      
      user.save.should be_false
    end
  end
  
  describe "user_folders" do
    describe "if user admin" do
      it "return all folder belong to organization" do
        organization = FactoryGirl.create(:organization)
        admin = FactoryGirl.create(:user, admin: true, organization: organization)
        folder = FactoryGirl.create(:folder, organization: organization, use_privacy: true, users: [])
        
        admin.user_folders.should include(folder)
      end
      
      it "should only return folder belong to use" do
        organization = FactoryGirl.create(:organization)
        user = FactoryGirl.create(:user, organization: organization)
        user2 = FactoryGirl.create(:user, organization: organization)
        folder = FactoryGirl.create(:folder, organization: organization, use_privacy: true, users: [user])
        
        user.user_folders.should include(folder)
        user2.user_folders.should_not include(folder)
      end
    end
  end
  
  describe "all_categories" do
    describe "with valid parameter" do
      it "should return all the categories belonging to organization" do
        @user = FactoryGirl.create(:user)
        @category1 = FactoryGirl.create(:category, organization: @user.organization)
        @category2 = FactoryGirl.create(:category)
        
        @user.all_categories.should eq([@category1])
      end
    end
    
    describe "with no organization" do
      it "should raise error" do
        @user = FactoryGirl.build(:user, organization: nil)
        @user.save(validation: false)
        expect {
          @user.all_categories
        }.to raise_error
      end
    end
  end
  
  describe "user_categories" do
    describe "with folder use_privacy" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @folder = FactoryGirl.create(:folder, organization: @user.organization, use_privacy: true)
        @category = FactoryGirl.create(:category, organization: @user.organization, folder: @folder)        
      end
      
      describe "user does not belong to the folder" do
        it "should not return folder" do
          @user.user_categories.should_not include(@category)
        end
      end
      
      describe "user belong to the folder" do
        it "should include the category" do
          folder = FactoryGirl.create(:folder, organization: @user.organization, use_privacy: true, users:[@user])
          category = FactoryGirl.create(:category, organization: @user.organization, folder: folder)
          
          @user.user_categories.should include(category)          
        end                
      end
      
      describe "category without a folder" do
        it "should return category" do
          category = FactoryGirl.create(:category, organization: @user.organization, folder: nil)          
          @user.user_categories.should include(category)          
          
        end
      end
    end
  end
  
  describe "user_activities" do
    describe "wihtout folder use_privacy" do
      before(:each) do
        @organization = FactoryGirl.create(:organization)
        @admin = FactoryGirl.create(:user, organization: @organization, admin:true)
        @user1 = FactoryGirl.create(:user, organization: @organization)
        @user2 = FactoryGirl.create(:user, organization: @organization)

        @category1 = FactoryGirl.create(:category, organization: @organization)
        @activity1 = FactoryGirl.create(:activity, organization: @organization, user: @user1, category: @category1)

        @category2 = FactoryGirl.create(:category, organization: @organization, use_privacy: true, users: [@user2])
        @activity2 = FactoryGirl.create(:activity, organization: @organization, user: @user2, category: @category2)      
      end

      it "return all activities on that organization if user is admin" do
        user_activities = @admin.user_activities
        user_activities.should include(@activity1)
        user_activities.should include(@activity2)
      end

      it "return only activities that user have access to" do
        @user1.user_activities.should include(@activity1)
        @user1.user_activities.should_not include(@activity2)

        @user2.user_activities.should include(@activity1)
        @user2.user_activities.should include(@activity2)
      end      
    end
    
    describe "with folder use_privacy true" do      
      describe "with folder does ot belong to user" do
        it "should not return the activity" do
          @user = FactoryGirl.create(:user)
          folder = FactoryGirl.create(:folder, organization: @user.organization, use_privacy: true)
          category = FactoryGirl.create(:category, organization: @user.organization, folder: folder)
          activity = FactoryGirl.create(:activity, organization: @user.organization, user: @user, category: category)

          @user.user_activities.should_not include(activity)
        end
      end
      
      describe "with folder belong to the user" do
        it "should return the activity" do
          @user = FactoryGirl.create(:user)
          folder = FactoryGirl.create(:folder, organization: @user.organization, use_privacy: true, users: [@user])
          category = FactoryGirl.create(:category, organization: @user.organization, folder: @folder)
          activity = FactoryGirl.create(:activity, organization: @user.organization, user: @user, category: category)

          @user.user_activities.should include(activity)          
        end        
      end
    end
  end
end

