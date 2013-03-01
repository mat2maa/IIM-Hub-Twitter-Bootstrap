class Split < ActiveRecord::Base
  has_many :audio_playlists, :through => :audio_playlist_tracks
  has_many :audio_playlist_tracks  
  validates_presence_of :name, :duration, :more_than, :less_than
  validates_numericality_of :duration, :more_than, :less_than

  attr_accessible :name, :duration, :more_than, :less_than
end
