class VideoDistributorsController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @video_distributors = VideoDistributor.find(:all, :order=>"name asc")	
	  respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @video_distributor = VideoDistributor.find(params[:id])
  end

  def new
    @video_distributor = VideoDistributor.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @video_distributor = VideoDistributor.new params[:video_distributor]
      if @video_distributor.save
        flash[:notice] = 'VideoDistributor was successfully created.'        
        format.html  { redirect_to(video_distributors_path) }
		    format.js
      else
      end
    end
  end
  
  def update
    @video_distributor = VideoDistributor.find(params[:id])

    respond_to do |format|
      if @video_distributor.update_attributes(params[:video_distributor])
        #Video.update_all(["video_distributor_cache=?",@video_distributor.name],["video_distributor_id=?",@video_distributor.id] )
        flash[:notice] = 'VideoDistributor was successfully updated.'
        format.html { redirect_to(video_distributors_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	  id = params[:id]
		@videos = Video.find(:all, :conditions => ["video_distributor_id = ?", id] )
		if @videos.length.zero?  
      @video_distributor = VideoDistributor.find(id)
      @video_distributor.destroy
		else
			flash[:notice] = 'Video Distributor could not be deleted, distributor is in use'
		end

    respond_to do |format|
      format.html { redirect_to(video_distributors_url) }
    end
  end
end
