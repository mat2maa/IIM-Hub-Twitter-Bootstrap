class VideoMasterPlaylistItemsController < ApplicationController
=begin
  in_place_edit_for :video_master_playlist_item,
                    :mastering
=end

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
        format.html { redirect_to(edit_video_master_playlist_path(@videomasterplaylistitem.video_master_playlist)) }
        format.js
        format.json { respond_with_bip(@videomasterplaylistitem) }
      else
        format.html { render action: "edit" }
        format.json { respond_with_bip(@videomasterplaylistitem) }
      end
    end
  end

  def destroy
    @videomasterplaylistitem = VideoMasterPlaylistItem.find(params[:id])

    @playlist = VideoMasterPlaylist.find(@videomasterplaylistitem.video_master_playlist.id)
    @playlist.updated_at_will_change!
    @playlist.save

    @videomasterplaylistitem.destroy

    respond_to do |format|
      flash[:notice] = 'Master was successfully deleted from playlist.'
      format.html #{ redirect_to(:back) }
      format.js
    end
  end

  def sort
    @videomasterplaylistitem = VideoMasterPlaylistItem.find(params[:id])

    # .attributes is a useful shorthand for mass-assigning
    # values via a hash
    @videomasterplaylistitem.update_attribute(:position_position, params[:position_position])

    if @videomasterplaylistitem.save
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end

    # this action will be called via ajax
  end
end
