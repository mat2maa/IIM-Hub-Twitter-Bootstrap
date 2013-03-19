class LaboratoriesController < ApplicationController
  before_filter :require_user
  filter_access_to :all

  def index
    @laboratories = Laboratory.find(:all,
                                    order: "name asc")
    respond_to do |format|
      format.html # index.html.erb
    end

  end

  def edit
    @laboratory = Laboratory.find(params[:id])
  end

  def new
    @laboratory = Laboratory.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    respond_to do |format|
      @laboratory = Laboratory.new params[:laboratory]
      if @laboratory.save
        flash[:notice] = 'Laboratory was successfully created.'
        format.html { redirect_to(laboratories_path) }
        format.js
      else
      end
    end
  end

  def update
    @laboratory = Laboratory.find(params[:id])

    respond_to do |format|
      if @laboratory.update_attributes(params[:laboratory])
        flash[:notice] = 'Laboratory was successfully updated.'
        format.html { redirect_to(laboratories_path) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy

    id = params[:id]
    @movies = Movie.find(:all,
                         conditions: ["laboratory_id = ?",
                                      id])
    if @movies.length.zero?
      @laboratory = Laboratory.find(id)
      @laboratory.destroy
    else
      flash[:notice] = 'Laboratory could not be deleted,
laboratory is in use in some tracks'
    end

    respond_to do |format|
      format.html { redirect_to(laboratories_url) }
    end
  end
end
