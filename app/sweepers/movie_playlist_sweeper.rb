class MoviePlaylistSweeper < ActionController::Caching::Sweeper
  observe MoviePlaylist
  
  def after_save(movie_playlist)
    expire_cache(movie_playlist)
  end
  
  def after_destroy(movie_playlist)
    expire_cache(movie_playlist)
  end
  
  def expire_cache(movie_playlist)
    Rails.cache.delete("views/movie_playlist_items*")
  end
end