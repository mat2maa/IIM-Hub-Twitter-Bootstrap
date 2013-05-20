class MoviePlaylistItem < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :movie_playlist_id

  belongs_to :movie
  belongs_to :movie_playlist
#  acts_as_list :scope => :movie_playlist

  attr_accessible :movie_id, :movie_playlist_id, :position, :position_position

  after_save :update_movie_in_playlist

  before_destroy :update_movie_in_playlist
  
  def update_movie_in_playlist
    movie = Movie.find(self.movie.id)
    movie.in_playlists = MoviePlaylist.includes("movies")
                                      .where("movies.id=#{self.movie.id}")
                                      .collect { |playlist| playlist.id }.join(',')
    movie.save(validate: false)
  end
end
