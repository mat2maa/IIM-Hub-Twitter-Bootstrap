class VideoPlaylist < ActiveRecord::Base
  has_many :video_playlist_items, :dependent => :destroy
  has_many :videos, :through => :video_playlist_items, :order => "position"

  belongs_to :airline
  belongs_to :user
  belongs_to :video_playlist_type
  
  scope :with_same_airline_and_video, lambda { |video_id, airline_id| {
    :select=>"video_playlists.id, video_playlists.airline_id, video_playlists.start_cycle", 
    :conditions=>"video_playlist_items.video_id=#{video_id} AND video_playlists.airline_id='#{airline_id}'",
    :joins=>"LEFT JOIN video_playlist_items on video_playlists.id=video_playlist_items.video_playlist_id"} }

  attr_accessible :airline_id, :video_playlist_type_id, :start_cycle, :end_cycle
  
  def video_playlist_items_sorted
    return VideoPlaylistItem.where(:video_playlist_id => self.id)
                            .order("position ASC")
	end
end
