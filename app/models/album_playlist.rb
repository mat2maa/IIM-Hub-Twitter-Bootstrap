class AlbumPlaylist < ActiveRecord::Base

  has_many :album_playlist_items, :dependent => :destroy
  has_many :albums, :through => :album_playlist_items
  
  belongs_to :program
  belongs_to :airline
  belongs_to :user
	
	def album_playlist_items_sorted
		#self.album_playlist_items.sort_by {|a| [a.position, a]}
    return AlbumPlaylistItem.where(:album_playlist_id => self.id).order(:position)
	end
	
  attr_accessible :client_playlist_code, :in_out, :start_playdate, :start_playdate, :start_playdate, :end_playdate,
                  :end_playdate, :end_playdate, :airline_id

end
