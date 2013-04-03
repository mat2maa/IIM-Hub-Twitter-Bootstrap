class AudioPlaylistTrack < ActiveRecord::Base
  include RankedModel

  belongs_to :audio_playlist
  belongs_to :track

  ranks :position, with_same: :audio_playlist_id

#  acts_as_list :scope => :audio_playlist

  attr_accessible :mastering, :split, :vo_duration, :audio_playlist_id, :track_id, :position, :position_position
end
