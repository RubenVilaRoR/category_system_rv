class UsersController < ApplicationController
  before_filter :authorize, :except => [:new, :create]
  
  def index
    @users = current_user.organization.users.where("name like ? OR email like ?", "%#{params[:q]}%", "%#{params[:q]}%")
    @users.each{|user| user.name = "#{user.name} (#{user.email})"}
    respond_to do |format|
      format.json { render json: @users.as_json(only: [:id, :name]) }
    end
  end

  def new
    @user = User.new
  end
  
  # POST /admin/users
  def create
    @user = User.new(params[:user])
    @user.active = true
    @user.admin = true
    
    @organization = Organization.new(name: params[:user][:organization_name])
    @user.organization = @organization
    
    # verify captcha if environment is not test
    if !Rails.env.test?
      captcha = verify_recaptcha
      flash[:error] = "Incorrect captcha" unless captcha
    else
      captcha = true
    end
    
    if captcha && @user.save
      redirect_to login_path, :notice => "Sucessfully signed up!"
    else
      render :new  
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes params[:user]
      flash[:notice] = "Successfully updated your account"
      redirect_to account_path
    else
      render :edit
    end
  end
end
