class LabelSweeper < ActionController::Caching::Sweeper
  observe Label
  
  def after_save(label)
    expire_cache(label)
  end
  
  def after_destroy(label)
    expire_cache(label)
  end
  
  def expire_cache(label)
    expire_fragment 'album_search_form'
    expire_fragment 'track_search_form'
  end
end