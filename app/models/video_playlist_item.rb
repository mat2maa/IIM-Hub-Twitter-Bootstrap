class VideoPlaylistItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :video_playlist
#  acts_as_list :scope => :video_playlist

  attr_accessible :video_id, :position, :video_playlist_id

  def after_save
    video = Video.find(self.video.id)
    video.in_playlists = VideoPlaylist.includes(:videos)
                                      .where("videos.id=#{self.video.id}")
                                      .collect{|playlist| playlist.id}.join(',')
    video.save(validate: false)
  end
  
  def before_destroy
    video = Video.find(self.video.id)
    video.in_playlists = VideoPlaylist.includes(:videos)
                                      .where("videos.id=#{self.video.id}")
                                      .collect{|playlist| playlist.id}.join(',')
    video.save(validate: false)
  end
  
end
