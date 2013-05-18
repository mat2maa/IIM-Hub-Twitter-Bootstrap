class ScreenerPlaylistItem < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :screener_playlist_id

  belongs_to :screener
  belongs_to :screener_playlist
#  acts_as_list :scope => :screener_playlist

  attr_accessible :screener_playlist_id, :screener_id, :position

  after_save :update_screener_in_playlist

  before_destroy :update_screener_in_playlist
  
  def update_screener_in_playlist
    screener = Screener.find(self.screener.id)
    screener.in_playlists = ScreenerPlaylist.includes("screeners")
                                            .where("screeners.id=#{self.screener.id}")
                                            .collect{|playlist| playlist.id}.join(',')
    screener.save(validate: false)
  end
end
