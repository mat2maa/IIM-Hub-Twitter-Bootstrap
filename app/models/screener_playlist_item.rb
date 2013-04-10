class ScreenerPlaylistItem < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :screener_playlist_id

  belongs_to :screener
  belongs_to :screener_playlist
#  acts_as_list :scope => :screener_playlist

  attr_accessible :screener_playlist_id, :screener_id, :position

  def after_save
    screener = Screener.find(self.screener.id)
    screener.in_playlists = ScreenerPlaylist.find(:all,
      :conditions => "screeners.id=#{self.screener.id}", 
      :include => "screeners").collect{|playlist| playlist.id}.join(',')
    screener.save(validate: false)
  end
  
  def before_destroy
    screener = Screener.find(self.screener.id)
    screener.in_playlists = ScreenerPlaylist.find(:all, 
      :conditions => "screeners.id=#{self.screener.id}", 
      :include => "screeners").collect{|playlist| playlist.id}.join(',')
    screener.save(validate: false)
  end
end
