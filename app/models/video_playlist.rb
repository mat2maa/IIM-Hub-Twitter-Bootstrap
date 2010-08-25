class VideoPlaylist < ActiveRecord::Base
  has_many :video_playlist_items, :dependent => :destroy
  has_many :videos, :through => :video_playlist_items, :order => "position"

  belongs_to :airline
  belongs_to :user
  
  def video_playlist_items_sorted
    return VideoPlaylistItem.find(:all, :conditions=>{:video_playlist_id => self.id}, :order_by=>:position)
	end
end
