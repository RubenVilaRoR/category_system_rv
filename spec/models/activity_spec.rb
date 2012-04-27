require 'spec_helper'

describe Activity do
  describe "with valid parameter" do
    it "should save to the database" do
      activity = FactoryGirl.build(:activity)
      activity.save.should be_true
    end
  end
  
  describe "without valid parameter" do
    it "should not save without date" do
      activity = FactoryGirl.build(:activity, date: nil)
      activity.save.should be_false
    end
    
    it "should not save without info" do
      activity = FactoryGirl.build(:activity, info: nil)
      activity.save.should be_false
    end

    it "should not save without user" do
      activity = FactoryGirl.build(:activity, user: nil)
      activity.save.should be_false
    end
    
    it "should not save without category" do
      activity = FactoryGirl.build(:activity, category: nil)
      activity.save.should be_false
    end
  end
end
