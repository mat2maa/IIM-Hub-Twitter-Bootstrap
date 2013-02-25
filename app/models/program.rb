class Program < ActiveRecord::Base

  has_many :audio_playlists
  has_many :album_playlists

  attr_accessible :name

end
