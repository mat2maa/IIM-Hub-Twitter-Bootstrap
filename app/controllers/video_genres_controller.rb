class VideoGenresController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @video_genres = VideoGenre.find(:all, :order=>"name asc")	
	  respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @video_genre = VideoGenre.find(params[:id])
  end

  def new
    @video_genre = VideoGenre.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @video_genre = VideoGenre.new params[:video_genre]
      if @video_genre.save
        flash[:notice] = 'VideoGenre was successfully created.'        
        format.html  { redirect_to(video_genres_path) }
		    format.js
      else
      end
    end
  end
  
  def update
    @video_genre = VideoGenre.find(params[:id])

    respond_to do |format|
      if @video_genre.update_attributes(params[:video_genre])
        #Video.update_all(["video_genre_cache=?",@video_genre.name],["video_genre_id=?",@video_genre.id] )
        flash[:notice] = 'VideoGenre was successfully updated.'
        format.html { redirect_to(video_genres_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	  id = params[:id]
		@videos = Video.find(:all, :conditions => ["video_genres_videos.video_genre_id = ?", id], :include => :video_genres )
		if @videos.length.zero?  
      @video_genre = VideoGenre.find(id)
      @video_genre.destroy
		else
			flash[:notice] = 'Video genre could not be deleted, video genre is in use by some videos'
		end

    respond_to do |format|
      format.html { redirect_to(video_genres_url) }
    end
  end
end
