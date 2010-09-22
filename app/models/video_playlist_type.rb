class VideoPlaylistType < ActiveRecord::Base
  has_many :screeners;
  has_many :video_master_playlists;
end
