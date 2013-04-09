class AlbumPlaylistItemsController < ApplicationController
  before_filter :require_user
  filter_access_to :all

  def new
    @albumplaylistitem = AlbumPlaylistItems.new
  end

  def update
    @albumplaylistitem = AlbumPlaylistItem.find(params[:id])
    respond_to do |format|
      if @albumplaylistitem.update_attributes(params[:album_playlist_item])
        format.html { redirect_to(edit_album_playlist_path(@albumplaylistitem.album_playlist)) }
        format.js
        format.json { respond_with_bip(@albumplaylistitem) }
      else
        format.html { render action: "edit" }
        format.json { respond_with_bip(@albumplaylistitem) }
      end
    end
  end

  def destroy
    @albumplaylistitem = AlbumPlaylistItem.find(params[:id])
    @albumplaylistitem.destroy

    respond_to do |format|
      flash[:notice] = 'Album was successfully deleted from playlist.'
      format.html #{ redirect_to(:back) }
      format.js
    end
  end


  def sort
    @albumplaylistitem = AlbumPlaylistItem.find(params[:id])

    # .attributes is a useful shorthand for mass-assigning
    # values via a hash
    @albumplaylistitem.update_attribute(:position_position, params[:position_position])

    if @albumplaylistitem.save
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end

    # this action will be called via ajax
  end
end
