class VideoMasterPlaylistItem < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :video_master_playlist_id

  belongs_to :master
  belongs_to :video_master_playlist
#  acts_as_list :scope => :video_master_playlist

  attr_accessible :mastering, :video_master_playlist_id, :master_id, :position
  
  after_save :update_master_in_playlist

  before_destroy :update_master_in_playlist
  
  def update_master_in_playlist
    master = Master.find(self.master.id)
    master.in_playlists = VideoMasterPlaylist.includes("masters")
                                             .where("masters.id=#{self.master.id}")
                                             .collect{|playlist| playlist.id}.join(',')
    master.save(validate: false)
  end
end
