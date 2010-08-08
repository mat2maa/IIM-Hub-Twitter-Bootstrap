class VideoPlaylistItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :video_playlist
  acts_as_list :scope => :video_playlist
end
