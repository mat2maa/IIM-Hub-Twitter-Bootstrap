class Vo < ActiveRecord::Base
  has_many :audio_playlists

  attr_accessible :name

end
