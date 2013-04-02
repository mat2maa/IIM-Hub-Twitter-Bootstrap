class MoviePlaylistItem < ActiveRecord::Base
  belongs_to :movie
  belongs_to :movie_playlist
#  acts_as_list :scope => :movie_playlist
  include RankedModel
  ranks :position

  attr_accessible :movie_id, :movie_playlist_id

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
