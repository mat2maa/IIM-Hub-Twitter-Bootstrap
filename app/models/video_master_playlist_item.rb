class VideoMasterPlaylistItem < ActiveRecord::Base
  belongs_to :master
  belongs_to :video_master_playlist
  acts_as_list :scope => :video_master_playlist
  
  def after_save
    master = Master.find(self.master.id)
    master.in_playlists = VideoMasterPlaylist.find(:all,
      :conditions => "masters.id=#{self.master.id}", 
      :include => "masters").collect{|playlist| playlist.id}.join(',')
    master.save(false)
  end
  
  def before_destroy
    master = Master.find(self.master.id)
    master.in_playlists = VideoMasterPlaylist.find(:all, 
      :conditions => "masters.id=#{self.master.id}", 
      :include => "masters").collect{|playlist| playlist.id}.join(',')
    master.save(false)
  end
end
