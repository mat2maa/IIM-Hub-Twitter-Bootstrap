class ScreenerPlaylistItem < ActiveRecord::Base
  belongs_to :screener
  belongs_to :screener_playlist
  acts_as_list :scope => :screener_playlist

  def after_save
    screener = Screener.find(self.screener.id)
    screener.in_playlists = ScreenerPlaylist.find(:all,
      :conditions => "screeners.id=#{self.screener.id}", 
      :include => "screeners").collect{|playlist| playlist.id}.join(',')
    screener.save(false)
  end
  
  def before_destroy
    screener = Screener.find(self.screener.id)
    screener.in_playlists = ScreenerPlaylist.find(:all, 
      :conditions => "screeners.id=#{self.screener.id}", 
      :include => "screeners").collect{|playlist| playlist.id}.join(',')
    screener.save(false)
  end
end
