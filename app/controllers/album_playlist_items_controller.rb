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
end
