class MoviePlaylist < ActiveRecord::Base
  has_many :movie_playlist_items, :dependent => :destroy
  has_many :movies, :through => :movie_playlist_items, :order => "position"

  belongs_to :airline
  belongs_to :user
  
  named_scope :with_same_airline_and_movie, lambda { |movie_id, airline_id| {
    :select=>"movie_playlists.id, movie_playlists.airline_id, movie_playlists.start_cycle", 
    :conditions=>"movie_playlist_items.movie_id=#{movie_id} AND movie_playlists.airline_id='#{airline_id}'",
    :joins=>"LEFT JOIN movie_playlist_items on movie_playlists.id=movie_playlist_items.movie_playlist_id"} }
  
  MOVIE_TYPE = ["Hollywood Movie", "Arabic Movie", "Asian Movies", "Chinese Movies", "Cantonese Movie", "Danish Movie", 
                "Dutch Movie", "European Movies",	"Finnish Movie", "French Movie", "German Movie", "Greek Movie", 
                "Hebrew Movie", "Hindi Movie", "Indonesian Movie", "Italian Movie", "Japanese Movie", "Korean Movie", 
                "Malay Movie", "Mandarin Movie", "Norwegian Movie", "Persian Movie", "Portuguese Movie", "Russian Movie", 
                "Spanish Movie", "Swedish Movie", "Thai Movie"]
  									
  def movie_playlist_items_sorted
    return MoviePlaylistItem.find(:all, :conditions=>{:movie_playlist_id => self.id}, :order_by=>:position)
	end
	
	def movies_already_programmed(movie_id)
	  MoviePlaylist.with_same_airline_and_movie(movie_id, airline_id)
	end
  
end
