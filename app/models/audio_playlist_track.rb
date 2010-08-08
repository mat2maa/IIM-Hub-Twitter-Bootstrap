class AudioPlaylistTrack < ActiveRecord::Base
  belongs_to :audio_playlist
  belongs_to :track
  acts_as_list :scope => :audio_playlist 
end
