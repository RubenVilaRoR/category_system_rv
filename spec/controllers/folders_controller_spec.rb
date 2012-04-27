require 'spec_helper'

describe FoldersController do
  
  def valid_attributes
    {name: 'Folder test'}
  end
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_user(@user)
    @folder = FactoryGirl.create(:folder, organization: @user.organization)
  end
   
  describe "GET index" do
    it "assigns folders as @folders for current organization" do
      other_folder = FactoryGirl.create(:folder)
      get :index, {}
      assigns(:folders).should eq([@folder])
    end
  end

  describe "GET new" do
    it "assigns a new folder as @folder" do
      get :new
      assigns(:folder).should be_a_new(Folder)
    end
  end

  describe "GET edit" do
    describe "with folder belongs to organization" do
      it "assigns the requested folder as @folder" do
        get :edit, {:id => @folder.to_param}
        assigns(:folder).should eq(@folder)
      end      
    end
    
    describe "with folder does not belong to organization" do
      it "should raise an exception" do
        other_folder = FactoryGirl.create(:folder)
        expect { get :edit, {:id => other_folder.to_param} }.to raise_exception
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Folder" do
        expect {
          post :create, {:folder => valid_attributes}
        }.to change(Folder, :count).by(1)
        
      end

      it "assigns a newly created folder as @folder" do
        post :create, {:folder => valid_attributes}
        assigns(:folder).should be_a(Folder)
        assigns(:folder).should be_persisted
      end
      
      it "assign the newly created folder to current user organization" do
        post :create, {:folder => valid_attributes}
        assigns(:folder).organization.should eq(@user.organization)        
      end

      it "redirects to the folder list" do
        post :create, {:folder => valid_attributes}
        response.should redirect_to(folders_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved folder as @folder" do
        # Trigger the behavior that occurs when invalid params are submitted
        Folder.any_instance.stub(:save).and_return(false)
        post :create, {:folder => {}}
        assigns(:folder).should be_a_new(Folder)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Folder.any_instance.stub(:save).and_return(false)
        post :create, {:folder => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested folder" do
        Folder.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => @folder.to_param, :folder => {'these' => 'params'}}
      end

      it "assigns the requested folder as @folder" do
        put :update, {:id => @folder.to_param, :folder => valid_attributes}
        assigns(:folder).should eq(@folder)
      end

      it "redirects to the folder index" do
        put :update, {:id => @folder.to_param, :folder => valid_attributes}
        response.should redirect_to(folders_path)
      end
    end

    describe "with invalid params" do
      it "assigns the folder as @folder" do
        Folder.any_instance.stub(:save).and_return(false)
        put :update, {:id => @folder.to_param, :folder => {}}
        assigns(:folder).should eq(@folder)
      end

      it "re-renders the 'edit' template" do
        Folder.any_instance.stub(:save).and_return(false)
        put :update, {:id => @folder.to_param, :folder => {}}
        response.should render_template("edit")
      end
      
      it "raise an exception to edit other organization folde" do
        other_folder = FactoryGirl.create(:folder)
        expect { put :update, {:id => other_folder.to_param, :folder => {}} }.to raise_exception
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested folder" do
      expect {
        delete :destroy, {:id => @folder.to_param}
      }.to change(Folder, :count).by(-1)
    end

    it "redirects to the folders list" do
      delete :destroy, {:id => @folder.to_param}
      response.should redirect_to(folders_url)
    end
    
    it "raise an exception when deleting other folder organization" do
      folder = FactoryGirl.create(:folder)
      expect { delete :destroy, {:id => folder.to_param} }.to raise_exception
    end
  end

end
