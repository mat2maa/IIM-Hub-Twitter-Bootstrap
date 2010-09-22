class ScreenerPlaylist < ActiveRecord::Base
  has_many :screener_playlist_items, :dependent => :destroy
  has_many :screeners, :through => :screener_playlist_items, :order => "position"

  belongs_to :airline
  belongs_to :user
  
  def screener_playlist_items_sorted
    return ScreenerPlaylistItem.find(:all, :conditions=>{:screener_playlist_id => self.id}, :order_by=>:position)
	end
end
