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

  def sort
    @videoplaylistitem = VideoPlaylistItem.find(params[:id])

    # .attributes is a useful shorthand for mass-assigning
    # values via a hash
    @videoplaylistitem.update_attribute(:position_position, params[:position_position])

    if @videoplaylistitem.save
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end

    # this action will be called via ajax
  end
end
