class AlbumSweeper < ActionController::Caching::Sweeper
  observe Album
  
  def after_save(album)
    expire_cache(album)
  end
  
  def after_update(album)
    expire_cache(album)
  end
  
  
  def after_destroy(album)
    expire_cache(album)
  end
  
  def expire_cache(album)
    Rails.cache.delete("views/album_playlist_items*")
  end
end