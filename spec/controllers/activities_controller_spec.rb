require 'spec_helper'

describe ActivitiesController do
  def valid_attributes
    {date: '2012-03-01', info: 'Info to the activity', tags: 'tag1, tag2', category_id: @category.id }
  end
  describe "user not logged in" do
    it "should redirect to login" do 
      tests = {new: :get, edit: :get, create: :post, update: :put, destroy: :delete}     
      tests.each do |action, method|
        send(method, action)
        response.should redirect_to(login_url)      
      end
    end
  end
  
  describe "user logged in" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      login_user(@user)
    end
    
    before(:each) do
      @organization = @user.organization
      @category = FactoryGirl.create(:category, organization: @organization)
      @activity = FactoryGirl.create(:activity, user: @user, category: @category, organization: @organization)
    end
    
    describe "GET index" do
      describe "user does not have access on category" do
        it "should not include the category" do
          @category.update_attribute(:use_privacy, true)
          get :index
          assigns(:activities).should_not include(@activity)
        end
      end
      
      describe "user is admin" do
        it "assign all activities" do
          get :index
          assigns(:activities).should eq([@activity])
        end
      end
    end
    
    describe "GET show" do    
      it "assigns the requested activity as @activity" do
        get :show, {:id => @activity.to_param}
        assigns(:activity).should eq(@activity)
      end
      
      it "should raise an error if user does not have access to category" do
        @category.update_attribute(:use_privacy, true)
        expect { get :show, {:id => @activity.to_param} }.to raise_exception        
      end
    end

    describe "GET new" do      
      it "assigns a new activity as @activity" do
        get :new, {}
        assigns(:activity).should be_a_new(Activity)
      end
    end

    describe "GET edit" do  
      it "assigns the requested activity as @activity" do
        get :edit, { :id => @activity.to_param }
        assigns(:activity).should eq(@activity)
      end
      
      it "should raise an error if user does not have access to category" do
        @category.update_attribute(:use_privacy, true)
        expect { get :edit, { :id => @activity.to_param } }.to raise_exception        
      end
    end

    describe "POST create" do
      before(:each) do
        @attributes = valid_attributes.merge(category_id: @category.id)
      end
      describe "with valid params" do
        it "creates a new activity" do
          expect {
            post :create, {:activity => @attributes }
          }.to change(Activity, :count).by(1)
        end

        it "assigns a newly created activity as @activity" do
          post :create, {:activity => @attributes}
          assigns(:activity).user.should eq(@user)
          assigns(:activity).should be_a(Activity)
          assigns(:activity).should be_persisted
          assigns(:activity).organization.should eq(@user.organization)
        end

        it "redirects to the created activity" do
          post :create, {:activity => valid_attributes}
          response.should redirect_to(activity_path(Activity.last))
        end
      end

      describe "with invalid params" do
          
        it "assigns a newly created but unsaved activity as @activity" do
          # Trigger the behavior that occurs when invalid params are submitted
          Activity.any_instance.stub(:save).and_return(false)
          post :create, {:activity => {}}
          assigns(:activity).should be_a_new(Activity)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Activity.any_instance.stub(:save).and_return(false)
          post :create, {:activity => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do      
        it "updates the requested activity" do
          Activity.any_instance.should_receive(:update_attributes).with({'info' => 'info text'})
          put :update, {:id => @activity.to_param, :activity => {'info' => 'info text'}}
        end

        it "assigns the requested activity as @activity" do
          put :update, {:id => @activity.to_param, :activity => valid_attributes}
          assigns(:activity).should eq(@activity)
        end

        it "redirects to the activity" do
          category = FactoryGirl.create(:category, organization: @user.organization)
          put :update, {:id => @activity.to_param, :activity => {category_id: category.id}}
          response.should redirect_to(activity_path(@activity))
        end
      end

      describe "with invalid params" do      
        it "assigns the activity as @activity" do
          Activity.any_instance.stub(:save).and_return(false)
          put :update, {:id => @activity.to_param, :activity => {}}
          assigns(:activity).should eq(@activity)
        end

        it "re-renders the 'edit' template" do
          Activity.any_instance.stub(:save).and_return(false)
          put :update, {:id => @activity.to_param, :activity => {}}
          response.should render_template("edit")
        end
        
        it "should raise an error if user does not have access to category" do
          @category.update_attribute(:use_privacy, true)
          expect { put :update, {:id => @activity.to_param, :activity => {}} }.to raise_exception        
        end
      end
    end

    describe "DELETE destroy" do
      describe "with valid params" do
        it "destroys the requested activity" do
	        expect {
	          delete :destroy, {:id => @activity.to_param}
	        }.to change(Activity, :count).by(-1)
	      end

	      it "redirects to the activities list" do
	        delete :destroy, {:id => @activity.to_param}
	        response.should redirect_to(activities_path)
	      end
      end
      
      describe "with invalid parameter" do
        it "should raise an error if user does not have access to category" do
          @category.update_attribute(:use_privacy, true)
          expect { delete :destroy, {:id => @activity.to_param} }.to raise_exception        
        end        
      end
    end        
  end
end
