class MoviePlaylistItem < ActiveRecord::Base
  belongs_to :movie
  belongs_to :movie_playlist
  acts_as_list :scope => :movie_playlist 

  def after_save
    movie = Movie.find(self.movie.id)
    movie.in_playlists = MoviePlaylist.find(:all,
      :conditions => "movies.id=#{self.movie.id}", 
      :include => "movies").collect{|playlist| playlist.id}.join(',')
    movie.save(false)
  end
  
  def before_destroy
    movie = Movie.find(self.movie.id)
    movie.in_playlists = MoviePlaylist.find(:all, 
      :conditions => "movies.id=#{self.movie.id}", 
      :include => "movies").collect{|playlist| playlist.id}.join(',')
    movie.save(false)
  end
  
end
