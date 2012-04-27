class CategoriesController < ApplicationController
  before_filter :authorize
  
  # GET /categories
  # GET /categories.json
  def index
    @search = Activity.search
    params[:q] = {s: 'color asc'}.merge(params[:q] || {}) #order by color by default
    
    if params[:folder].present?
      @folder = Folder.find(params[:folder])
      params[:q][:folder_id_eq] = @folder.id
    end

    @q = current_user.user_categories.search(params[:q])

    @categories = @q.result
    @folders = current_user.organization.folders.order('position').all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = current_user.user_categories.find(params[:id])  
    @search = @category.activities.search(params[:q])
    @activities = @search.result.page params[:page]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = current_user.user_categories.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
    @folder = sanitized_folder(params[:category])
    @category = Category.new(params[:category])
    @category.organization = current_user.organization
    @category.folder = @folder

    respond_to do |format|
      if @category.save
        format.html { redirect_to category_path(@category), notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @folder = sanitized_folder(params[:category])      
    current_user.user_categories.find(params[:id]) # make sure it exists or else raise execption
    @category = Category.find(params[:id])
    @category.folder = @folder

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to category_path(@category), notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = current_user.user_categories.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end  
  
  private
  def sanitized_folder(params)
    #sanitize folder_id
    folder_id = params.delete(:folder_id)
    if folder_id.present?
      @folder = current_user.organization.folders.find(folder_id)
    end
  end
end
