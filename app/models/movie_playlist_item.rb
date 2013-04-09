class MoviePlaylistItem < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :movie_playlist_id

  belongs_to :movie
  belongs_to :movie_playlist
#  acts_as_list :scope => :movie_playlist

  attr_accessible :movie_id, :movie_playlist_id, :position_position

  def after_save
    movie = Movie.find(self.movie.id)
    movie.in_playlists = MoviePlaylist.where("movies.id=#{self.movie.id}")
                                      .includes("movies")
                                      .collect { |playlist| playlist.id }.join(',')
    movie.save(validate: false)
  end

  def before_destroy
    movie = Movie.find(self.movie.id)
    movie.in_playlists = MoviePlaylist.where("movies.id=#{self.movie.id}")
                                      .includes("movies")
                                      .collect { |playlist| playlist.id }.join(',')
    movie.save(validate: false)
  end

end
