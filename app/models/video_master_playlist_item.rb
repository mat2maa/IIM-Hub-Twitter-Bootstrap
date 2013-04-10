class VideoMasterPlaylistItem < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :video_master_playlist_id

  belongs_to :master
  belongs_to :video_master_playlist
#  acts_as_list :scope => :video_master_playlist

  attr_accessible :mastering, :video_master_playlist_id, :master_id, :position
  
  def after_save
    master = Master.find(self.master.id)
    master.in_playlists = VideoMasterPlaylist.where("masters.id=#{self.master.id}")
                                             .includes("masters")
                                             .collect{|playlist| playlist.id}.join(',')
    master.save(validate: false)
  end
  
  def before_destroy
    master = Master.find(self.master.id)
    master.in_playlists = VideoMasterPlaylist.where("masters.id=#{self.master.id}")
                                             .includes("masters")
                                             .collect{|playlist| playlist.id}.join(',')
    master.save(validate: false)
  end
end
