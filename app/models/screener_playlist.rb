class ScreenerPlaylist < ActiveRecord::Base
  has_many :screener_playlist_items, :dependent => :destroy
  has_many :screeners, :through => :screener_playlist_items, :order => "position"
  belongs_to :video_playlist_type

  belongs_to :airline
  belongs_to :user

  scope :with_same_airline_and_screener, lambda { |screener_id, airline_id| {
    :select=>"screener_playlists.id, screener_playlists.airline_id, screener_playlists.start_cycle", 
    :conditions=>"screener_playlist_items.screener_id=#{screener_id} AND screener_playlists.airline_id='#{airline_id}'",
    :joins=>"LEFT JOIN screener_playlist_items on screener_playlists.id=screener_playlist_items.screener_playlist_id"} }

  attr_accessible :airline_id, :start_cycle, :end_cycle, :video_playlist_type_id, :media_instruction, :user_id

  def screener_playlist_items_sorted
    return ScreenerPlaylistItem.where(:screener_playlist_id => self.id)
                               .order("position ASC")
	end
end
