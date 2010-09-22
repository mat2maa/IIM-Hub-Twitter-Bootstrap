class VideoPlaylistTypesController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @video_playlist_types = VideoPlaylistType.find(:all, :order=>"name asc")	
	  respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @video_playlist_type = VideoPlaylistType.find(params[:id])
  end

  def new
    @video_playlist_type = VideoPlaylistType.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @video_playlist_type = VideoPlaylistType.new params[:video_playlist_type]
      if @video_playlist_type.save
        flash[:notice] = 'VideoPlaylistType was successfully created.'        
        format.html  { redirect_to(video_playlist_types_path) }
		    format.js
      else
      end
    end
  end
  
  def update
    @video_playlist_type = VideoPlaylistType.find(params[:id])

    respond_to do |format|
      if @video_playlist_type.update_attributes(params[:video_playlist_type])
        #Movie.update_all(["video_playlist_type_cache=?",@video_playlist_type.name],["video_playlist_type_id=?",@video_playlist_type.id] )
        flash[:notice] = 'VideoPlaylistType was successfully updated.'
        format.html { redirect_to(video_playlist_types_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	  id = params[:id]
		@master_playlists = VideoMasterPlaylistItem.find(:all, :conditions => ["video_playlist_type_id = ?", id] )
		@screener_playlists = ScreenerPlaylistItem.find(:all, :conditions => ["video_playlist_type_id = ?", id] )
		if @master_playlists.length.zero? &&  @screener_playlists.length.zero?  
      @video_playlist_type = VideoPlaylistType.find(id)
      @video_playlist_type.destroy
		else
			flash[:notice] = 'VideoPlaylistType could not be deleted, video_playlist_type is in use in some tracks'
		end

    respond_to do |format|
      format.html { redirect_to(video_playlist_types_url) }
    end
  end
end
