class MoviePlaylistItemsController < ApplicationController
  before_filter :require_user
  filter_access_to :all

  def new
    @movieplaylistitem = MoviePlaylistItems.new
  end

  def destroy
    @movieplaylistitem = MoviePlaylistItem.find(params[:id])
    @movieplaylistitem.destroy

    respond_to do |format|
      flash[:notice] = 'Movie was successfully deleted from playlist.'
      format.html
      format.js
    end
  end

  def sort
    @movieplaylistitem = MoviePlaylistItem.find(params[:id])

    # .attributes is a useful shorthand for mass-assigning
    # values via a hash
    @movieplaylistitem.update_attribute(:position_position, params[:position_position])

    if @movieplaylistitem.save
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end

    # this action will be called via ajax
  end
end
