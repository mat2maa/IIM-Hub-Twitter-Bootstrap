class VideoSweeper < ActionController::Caching::Sweeper
  observe Video
  
  def after_save(video)
    expire_cache(video)
  end
  
  def after_destroy(video)
    expire_cache(video)
  end
  
  def expire_cache(video)
    Rails.cache.delete("views/video_playlist_items*")
  end
  
  def expire_cache(video)
    Rails.cache.delete("views/video_master_playlist_items*")
  end
end