class MoviePlaylist < ActiveRecord::Base
  has_many :movie_playlist_items, :dependent => :destroy
  has_many :movies, :through => :movie_playlist_items

  belongs_to :airline
  belongs_to :user
  
  def movie_playlist_items_sorted
    return MoviePlaylistItem.find(:all, :conditions=>{:movie_playlist_id => self.id}, :order_by=>:position)
	end
  
end
