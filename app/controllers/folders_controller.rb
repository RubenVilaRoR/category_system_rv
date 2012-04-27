class FoldersController < ApplicationController
  before_filter :authorize
  
  # GET /folders
  # GET /folders.json
  def index
    @folders = current_user.organization.folders.order('position')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @folders }
    end
  end

  # GET /folders/new
  # GET /folders/new.json
  def new
    @folder = Folder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @folder }
    end
  end

  # GET /folders/1/edit
  def edit
    @folder = current_user.organization.folders.find(params[:id])
  end

  # POST /folders
  # POST /folders.json
  def create
    @folder = Folder.new(params[:folder])
    @folder.organization = current_user.organization
    
    respond_to do |format|
      if @folder.save
        format.html { redirect_to folders_path, notice: 'Folder was successfully created.' }
        format.json { render json: @folder, status: :created, location: @folder }
      else
        format.html { render action: "new" }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /folders/1
  # PUT /folders/1.json
  def update
    @folder = current_user.organization.folders.find(params[:id])

    respond_to do |format|
      if @folder.update_attributes(params[:folder])
        format.html { redirect_to folders_path, notice: 'Folder was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    @folder = current_user.organization.folders.find(params[:id])
    @folder.destroy

    respond_to do |format|
      format.html { redirect_to folders_url }
      format.json { head :no_content }
    end
  end
  
  def sort
    params[:folder].each_with_index do |id, index|
      Folder.update_all({position: index+1}, {id: id})
    end
    render nothing: true 
  end
end
