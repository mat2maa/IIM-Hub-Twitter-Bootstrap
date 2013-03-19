class ScreenerPlaylistItemsController < ApplicationController
  before_filter :require_user
  filter_access_to :all

  def new
    @screenerplaylistitem = ScreenerPlaylistItems.new
  end

  def destroy
    @screenerplaylistitem = ScreenerPlaylistItem.find(params[:id])
    @screenerplaylistitem.destroy

    respond_to do |format|
      flash[:notice] = 'Screener was successfully deleted from playlist.'
      format.html
      format.js
    end
  end
end
