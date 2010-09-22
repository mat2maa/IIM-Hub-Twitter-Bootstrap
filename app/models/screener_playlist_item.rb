class ScreenerPlaylistItem < ActiveRecord::Base
  belongs_to :screener
  belongs_to :screener_playlist
  acts_as_list :scope => :screener_playlist

end
