require 'spec_helper'
describe CategoriesController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_user(@user)
    @category = FactoryGirl.create(:category, organization: @user.organization, users: [@user])
  end
  
  def valid_attributes
    {name: 'Category 11'}
  end
  
  describe "GET index" do
    it "assigns all categories as @categories that belong to the same organization" do
      category2 = FactoryGirl.create(:category)
      get :index, {}
      assigns(:categories).should eq([@category])
    end
    
    describe "with use privacy set to true" do
      describe "user is admin" do
        it "should show all categories" do
          admin = FactoryGirl.create(:user, admin: true)
          category_no_user = FactoryGirl.create(:category, organization: admin.organization, use_privacy: true, users: [])
          login_user(admin)
          get :index, {}
          assigns(:categories).should eq([category_no_user])
        end
      end
      
      describe "user is not admin" do
        it "only show category of that user" do        
          category_no_user = FactoryGirl.create(:category, organization: @user.organization, use_privacy: true, users: [])
          category_no_user.users.should be_empty
          get :index, {}
          assigns(:categories).should eq([@category])
        end        
      end      
    end
  end

  describe "GET show" do
    describe "with category not belong to the organization" do
      it "will raise error" do
        category = FactoryGirl.create(:category)
        category.organization.should_not eq(@user.organization)
        expect {
          get :show, {:id => category.to_param}
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
    
    describe "with category use_privacy true" do
      describe "user is admin" do
        it "should addign category" do
          admin = FactoryGirl.create(:user, admin: true)
          login_user(admin)
          category_no_user = FactoryGirl.create(:category, organization: admin.organization, use_privacy: true, users: [])
          get :show, {:id => category_no_user.to_param}
          assigns(:category).should eq(category_no_user)
        end
      end
      
      describe "user is not admin" do
        it "shoudl raise an exception if user is not included in the category" do
          category_no_user = FactoryGirl.create(:category, organization: @user.organization, use_privacy: true, users: [])
          expect {
            get :show, {:id => category_no_user.to_param}
          }.to raise_error ActiveRecord::RecordNotFound
        end                  

        it "should assign category if user is included in the category" do
          category = FactoryGirl.create(:category, organization: @user.organization, use_privacy: true, users: [@user])
          get :show, {:id => category.to_param}
          assigns(:category).should eq(category)          
        end
      end
    end
    
    describe "with category user_privacy false" do
      it "assigns the requested category as @category" do
        get :show, {:id => @category.to_param}
        assigns(:category).should eq(@category)
      end      
    end
  end

  describe "GET new" do
    it "assigns a new category as @category" do
      get :new, {}
      assigns(:category).should be_a_new(Category)
    end
  end

  describe "GET edit" do
    describe "with category not belong to the organization" do
      it "will raise error" do
        category = FactoryGirl.create(:category)
        category.organization.should_not eq(@user.organization)
        expect {
          get :edit, {:id => category.to_param}
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
    
    describe "with category belonging to the organization" do
      it "assigns the requested category as @category" do
        get :edit, {:id => @category.to_param}
        assigns(:category).should eq(@category)
      end      
    end
  end

  describe "POST create" do    
    describe "with valid params" do
      it "creates a new Category" do
        expect {
          category = FactoryGirl.create(:category)
          post :create, {:category => {name: 'Category 11', user_tokens: "#{@user.id}"}}
        }.to change(Category, :count).by(2) and change(@user.categories, :count).by(1)
      end

      it "assign current_user organization as category's organization" do
        post :create, {:category => {name: 'Category 11', user_tokens: "#{@user.id}"}}
        assigns(:category).organization.should eq(@user.organization)
      end
      
      it "assigns a newly created category as @category" do
        post :create, {:category => {name: 'Category 11', user_tokens: "#{@user.id}"}}
        assigns(:category).should be_a(Category)
        assigns(:category).should be_persisted
      end
      
      it "assign the category privacy and user" do
        post :create, {:category => {name: 'Category 11', use_privacy: 1, user_tokens: "#{@user.id}"}}
        assigns(:category).users.should eq([@user])
        assigns(:category).use_privacy.should be_true
      end

      it "redirects to the created category" do
        post :create, {:category => valid_attributes}
        response.should redirect_to(category_path(Category.last))
      end
      
      describe "with existing name same organization" do
        it "render edit again" do
          category = FactoryGirl.create(:category, organization: @user.organization, name: 'category1')
          expect {
            post :create, {:category => {name: 'category1'}}
          }.to change(Category, :count).by(0)
          response.should render_template("new")          
        end        
      end
      
      describe "with existing name on different organization" do
        it "save the category" do
          category = FactoryGirl.create(:category, name: 'category1')
          post :create, {:category => {name: 'category1'}}
          assigns(:category).should be_persisted
        end
      end
    end

    describe "with invalid params" do
      before(:each) do
        Category.any_instance.stub(:save).and_return(false)
        post :create, {:category => {}}
      end
      it "assigns a newly created but unsaved category as @category" do
        # Trigger the behavior that occurs when invalid params are submitted        
        assigns(:category).should be_a_new(Category)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with category not belong to the organization" do
      it "will raise error" do
        category = FactoryGirl.create(:category)
        expect {
          put :update, {:id => category.to_param, :category => {'name' => 'params'}}
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
    
    describe "with category belonging to the organization" do
      describe "with valid params" do
        it "updates the requested category" do
          Category.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => @category.to_param, :category => {'these' => 'params'}}
        end

        it "assigns the requested category as @category" do
          put :update, {:id => @category.to_param, :category => valid_attributes}
          assigns(:category).should eq(@category)
        end
        
        it "assign use_privacy and user selected" do
          put :update, {:id => @category.to_param, :category => {name: 'Category edit', use_privacy: true, user_tokens: "#{@user.id}"}}
          assigns(:category).users.should eq([@user])
          assigns(:category).use_privacy.should be_true
        end

        it "redirects to the category" do
          put :update, {:id => @category.to_param, :category => valid_attributes}
          response.should redirect_to(category_path(Category.last))
        end
      end      
    end

    describe "with invalid params" do
      before(:each) do
        Category.any_instance.stub(:save).and_return(false)
        put :update, {:id => @category.to_param, :category => {}}        
      end
      it "assigns the category as @category" do
        assigns(:category).should eq(@category)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => @category.to_param, :category => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    describe "with category not belong to the organization" do
      it "will raise error" do
        category = FactoryGirl.create(:category)
        expect {
          delete :destroy, {:id => category.to_param}
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
    
    describe "with category belonging to the organization" do
      it "destroys the requested category" do
        expect {
          delete :destroy, {:id => @category.to_param}
        }.to change(Category, :count).by(-1)
      end

      it "redirects to the categories list" do
        delete :destroy, {:id => @category.to_param}
        response.should redirect_to(categories_url)
      end      
    end
  end

end
