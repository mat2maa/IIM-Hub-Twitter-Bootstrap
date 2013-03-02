class VideoPlaylistType < ActiveRecord::Base
  has_many :screeners;
  has_many :video_master_playlists;
  has_many :screener_playlists;

  attr_accessible :name
end
