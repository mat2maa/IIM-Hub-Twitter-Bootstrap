class VideoPlaylistItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :video_playlist
  acts_as_list :scope => :video_playlist
  
  def after_save
    video = Video.find(self.video.id)
    video.in_playlists = VideoPlaylist.find(:all,
      :conditions => "videos.id=#{self.video.id}", 
      :include => "videos").collect{|playlist| playlist.id}.join(',')
    video.save(false)
  end
  
  def before_destroy
    video = Video.find(self.video.id)
    video.in_playlists = VideoPlaylist.find(:all, 
      :conditions => "videos.id=#{self.video.id}", 
      :include => "videos").collect{|playlist| playlist.id}.join(',')
    video.save(false)
  end
  
end
