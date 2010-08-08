class MovieSweeper < ActionController::Caching::Sweeper
  observe Video
  
  def after_save(movie)
    expire_cache(movie)
  end
  
  def after_destroy(movie)
    expire_cache(movie)
  end
  
  def expire_cache(movie)
    Rails.cache.delete("views/movie_playlist_items*")
  end
end