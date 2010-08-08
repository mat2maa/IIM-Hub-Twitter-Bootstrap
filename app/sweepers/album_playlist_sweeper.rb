class AlbumPlaylistSweeper < ActionController::Caching::Sweeper
  observe AlbumPlaylist
  
  def after_save(album_playlist)
    expire_cache(album_playlist)
  end
  
  def after_destroy(album_playlist)
    expire_cache(album_playlist)
  end
  
  def expire_cache(album_playlist)
    Rails.cache.delete("views/album_playlist_items*")
  end
end