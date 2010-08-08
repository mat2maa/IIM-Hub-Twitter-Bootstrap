class ProductionStudiosController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @production_studios = ProductionStudio.find(:all, :order=>"name asc")	
	respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @production_studio = ProductionStudio.find(params[:id])
  end

  def new
    @production_studio = ProductionStudio.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @production_studio = ProductionStudio.new params[:production_studio]
      if @production_studio.save
        flash[:notice] = 'ProductionStudio was successfully created.'        
        format.html  { redirect_to(production_studios_path) }
		    format.js
      else
      end
    end
  end
  
  def update
    @production_studio = ProductionStudio.find(params[:id])

    respond_to do |format|
      if @production_studio.update_attributes(params[:production_studio])
        flash[:notice] = 'ProductionStudio was successfully updated.'
        format.html { redirect_to(production_studios_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
		id = params[:id]
		@movies = Movie.find(:all, :conditions => ["laboratory_id = ?", id] )
		if @movies.length.zero?
      @production_studio = ProductionStudio.find(id)
      @production_studio.destroy
		else
			flash[:notice] = 'ProductionStudio could not be deleted, production_studio is in use in some tracks'
		end

    respond_to do |format|
      format.html { redirect_to(production_studios_url) }
    end
  end

end