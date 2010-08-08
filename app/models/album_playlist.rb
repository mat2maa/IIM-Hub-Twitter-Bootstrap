class AlbumPlaylist < ActiveRecord::Base

  has_many :album_playlist_items, :dependent => :destroy
  has_many :albums, :through => :album_playlist_items
  
  belongs_to :program
  belongs_to :airline
  belongs_to :user
	
	def album_playlist_items_sorted
		#self.album_playlist_items.sort_by {|a| [a.position, a]}
    return AlbumPlaylistItem.find(:all, :conditions=>{:album_playlist_id => self.id}, :order_by=>:position)
	end
	
end
