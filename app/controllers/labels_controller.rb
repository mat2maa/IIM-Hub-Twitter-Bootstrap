class LabelsController < ApplicationController
  before_filter :require_user
  cache_sweeper :label_sweeper, :only => [:new, :create, :update, :destroy]
	filter_access_to :all

  def index
    @labels = Label.find(:all, :order=>"name asc")	
	respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @label = Label.find(params[:id])
  end

  def new
    @label = Label.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @label = Label.new params[:label]
      if @label.save
        flash[:notice] = 'Label was successfully created.'        
        format.html  { redirect_to(labels_path) }
		format.js
      else
      end
    end
  end
  
  def update
    @label = Label.find(params[:id])

    respond_to do |format|
      if @label.update_attributes(params[:label])
        flash[:notice] = 'Label was successfully updated.'
        format.html { redirect_to(labels_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	
	@albums = Album.find(:all, :conditions => ["label_id = ?", params[:id]] )	
		
	if  @albums.length.zero?
  
      @label = Label.find(params[:id])
      @label.destroy
	  
	else
	  flash[:notice] = 'Label could not be deleted, label is in use in some albums or tracks'
	end
	

    respond_to do |format|
      format.html { redirect_to(labels_url) }
    end
  end
end