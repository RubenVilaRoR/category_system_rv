require 'spec_helper'

describe Organization do
  describe "With valid parameter" do
    it "should save to database" do
      organization = FactoryGirl.build(:organization)
      organization.save.should be_true
    end
    
    it "should increase the counter cache on a new user" do
      organization = FactoryGirl.create(:organization)
      user = FactoryGirl.create(:user, organization: organization)
      organization.reload
      organization.users_count.should eq(1)
    end
  end
  
  describe "without valid parameter" do
    it "should not save without name" do
      organization = FactoryGirl.build(:organization, name: nil)
      organization.save.should be_false
    end
  end
end
