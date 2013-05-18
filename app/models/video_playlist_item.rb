class VideoPlaylistItem < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :video_playlist_id

  belongs_to :video
  belongs_to :video_playlist
#  acts_as_list :scope => :video_playlist

  attr_accessible :video_id, :position, :video_playlist_id

  after_save :update_video_in_playlist

  before_destroy :update_video_in_playlist
  
  def update_video_in_playlist
    video = Video.find(self.video.id)
    video.in_playlists = VideoPlaylist.includes(:videos)
                                      .where("videos.id=#{self.video.id}")
                                      .collect{|playlist| playlist.id}.join(',')
    video.save(validate: false)
  end
end
