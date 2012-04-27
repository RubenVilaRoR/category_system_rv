class Admin::UsersController < Admin::AdminController
  # GET /admin/users
  def index
    @users = current_user.organization.users.order('name asc')
  end
  
  # GET /admin/users/new
  def new
     @user = User.new
     @user.active = true
  end
  
  # GET /admin/user/:id/edit
  def edit
    @user = current_user.organization.users.find(params[:id])
  end

  # POST /admin/users
  def create
    @user = User.new(params[:user], as: :admin)
    @user.organization = current_user.organization
    if @user.save
      redirect_to admin_users_path, :notice => "Sucessfully signed up!"
    else
      render :new  
    end
  end
  
  def update
    @user = current_user.organization.users.find(params[:id])
    if @user.update_attributes params[:user], as: :admin
      flash.notice = "Successfully updated user #{@user.username}"
      redirect_to admin_users_path
    else
      render :edit
    end
  end
  
  # DELETE /admin/user/:id
  def destroy
    @user = current_user.organization.users.find(params[:id])
    if @user.destroy
      flash[:notice] = "Sucessfully Deleted #{@user.username}"
    end
    redirect_to admin_users_path 
  end
  
end
