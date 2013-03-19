class AlbumPlaylistItemsController < ApplicationController
  before_filter :require_user
  filter_access_to :all

  def new
    @albumplaylistitem = AlbumPlaylistItems.new
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
