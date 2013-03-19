class AudioPlaylistTracksController < ApplicationController
  in_place_edit_for :audio_playlist_track,
                    :mastering
  in_place_edit_for :audio_playlist_track,
                    :split

  before_filter :require_user
  filter_access_to :all

  def new
    @audioplaylisttrack = AudioPlaylistTracks.new
  end

  def update
    @audioplaylisttrack = AudioPlaylistTrack.find(params[:id])
    respond_to do |format|
      if @audioplaylisttrack.update_attributes(params[:audio_playlist_track])
        flash[:notice] = 'Mastering was successfully updated.'
        format.html { redirect_to(edit_audio_playlist_path(@audioplaylisttrack.audio_playlist)) }
        format.js
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @audioplaylisttrack = AudioPlaylistTrack.find(params[:id])

    @audio_playlist = AudioPlaylist.find(@audioplaylisttrack.audio_playlist.id)
    @audio_playlist.updated_at_will_change!
    @audio_playlist.save

    @audioplaylisttrack.destroy

    respond_to do |format|
      flash[:notice] = 'Track was successfully deleted from playlist.'
      format.html #{ redirect_to(:back) }
      format.js
    end
  end


end
