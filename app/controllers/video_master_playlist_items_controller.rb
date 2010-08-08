class VideoMasterPlaylistItemsController < ApplicationController
  in_place_edit_for :video_master_playlist_item, :mastering

  before_filter :require_user
	filter_access_to :all
  
  def new
    @videomasterplaylistitem = VideoMasterPlaylistItem.new
  end
  
  def update
    @videomasterplaylistitem = VideoMasterPlaylistItem.find(params[:id])
    respond_to do |format|
      if @videomasterplaylistitem.update_attributes(params[:video_master_playlist_item])
        flash[:notice] = 'Mastering was successfully updated.'
        format.html { redirect_to(edit_audio_playlist_path(@videomasterplaylistitem.video_master_playlist)) }
        format.js
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @videomasterplaylistitem = VideoMasterPlaylistItem.find(params[:id])

	  @audio_playlist = VideoMasterPlaylist.find(@videomasterplaylistitem.video_master_playlist.id) 
  	@audio_playlist.updated_at_will_change!
    @audio_playlist.save
    
  	@videomasterplaylistitem.destroy
	
    respond_to do |format|
  	  flash[:notice] = 'Master was successfully deleted from playlist.'
      format.html #{ redirect_to(:back) }
      format.js
    end
  end
end
