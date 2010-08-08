class VideoMasterPlaylistItem < ActiveRecord::Base
  belongs_to :master
  belongs_to :video_master_playlist
  acts_as_list :scope => :video_master_playlist
end
