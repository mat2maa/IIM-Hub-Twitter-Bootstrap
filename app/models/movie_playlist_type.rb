class MoviePlaylistType < ActiveRecord::Base
  has_many :movie_playlists
  validates_presence_of :name
  
  attr_accessible :name
end
