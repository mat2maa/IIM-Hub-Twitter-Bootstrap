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

  def sort
    @screenerplaylisttiem = ScreenerPlaylistItem.find(params[:id])

    # .attributes is a useful shorthand for mass-assigning
    # values via a hash
    @screenerplaylisttiem.update_attribute(:position_position, params[:position_position])

    if @screenerplaylisttiem.save
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end

    # this action will be called via ajax
  end
end
