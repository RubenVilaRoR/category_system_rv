require 'spec_helper'

describe ApplicationHelper do
  describe "alert_class" do
    it "display the class of the error" do
      helper.alert_class(:error).should eq("alert-error")
      helper.alert_class(:notice).should eq("alert-success")
      helper.alert_class(:alert).should eq("alert-info")
    end
  end
end