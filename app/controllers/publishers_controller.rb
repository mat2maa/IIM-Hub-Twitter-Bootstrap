class PublishersController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @publishers = Publisher.find(:all, :order=>"name asc")	
	respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @publisher = Publisher.find(params[:id])
  end

  def new
    @publisher = Publisher.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @publisher = Publisher.new params[:publisher]
      if @publisher.save
        flash[:notice] = 'Publisher was successfully created.'        
        format.html  { redirect_to(publishers_path) }
		format.js
      else
      end
    end
  end
  
  def update
    @publisher = Publisher.find(params[:id])

    respond_to do |format|
      if @publisher.update_attributes(params[:publisher])
        flash[:notice] = 'Publisher was successfully updated.'
        format.html { redirect_to(publishers_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	
	@albums = Album.find(:all, :conditions => ["publisher_id = ?", params[:id]] )	
		
	if  @albums.length.zero?
  
      @publisher = Publisher.find(params[:id])
      @publisher.destroy
	  
	else
	  flash[:notice] = 'Publisher could not be deleted, publisher is in use in some albums or tracks'
	end

    respond_to do |format|
      format.html { redirect_to(publishers_url) }
    end
  end
end
