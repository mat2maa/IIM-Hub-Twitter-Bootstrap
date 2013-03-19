class VideoPlaylistItemsController < ApplicationController
  before_filter :require_user
  filter_access_to :all

  def new
    @videoplaylistitem = VideoPlaylistItems.new
  end

  def destroy
    @videoplaylistitem = VideoPlaylistItem.find(params[:id])
    @videoplaylistitem.destroy

    respond_to do |format|
      flash[:notice] = 'Video was successfully deleted from playlist.'
      format.html
      format.js
    end
  end
end
