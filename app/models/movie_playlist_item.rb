class MoviePlaylistItem < ActiveRecord::Base
  belongs_to :movie
  belongs_to :movie_playlist
  acts_as_list :scope => :movie_playlist 
  
end
