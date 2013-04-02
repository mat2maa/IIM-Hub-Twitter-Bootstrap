class AudioPlaylistTrack < ActiveRecord::Base
  belongs_to :audio_playlist
  belongs_to :track
#  acts_as_list :scope => :audio_playlist

  attr_accessible :mastering, :split, :vo_duration
end
