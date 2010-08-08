class OriginsController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @origins = Origin.find(:all, :order=>"name asc")	
	respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @origin = Origin.find(params[:id])
  end

  def new
    @origin = Origin.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @origin = Origin.new params[:origin]
      if @origin.save
        flash[:notice] = 'Origin was successfully created.'        
        format.html  { redirect_to(origins_path) }
				format.js
      else
      end
    end
  end
  
  def update
    @origin = Origin.find(params[:id])

    respond_to do |format|
      if @origin.update_attributes(params[:origin])
        flash[:notice] = 'Origin was successfully updated.'
        format.html { redirect_to(origins_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
   
	
	@tracks = Track.find(:all, :conditions => ["origin_id = ?", params[:id]] )	
		
	if  @tracks.length.zero?
  
      @origin = Origin.find(params[:id])
      @origin.destroy
	  
	else
	  flash[:notice] = 'Origin could not be deleted, origin is in use in some tracks'
	end

    respond_to do |format|
      format.html { redirect_to(origins_url) }
    end
  end
end
