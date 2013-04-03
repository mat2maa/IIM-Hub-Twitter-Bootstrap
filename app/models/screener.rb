class Screener < ActiveRecord::Base

  belongs_to :video, :counter_cache => true
  validates_presence_of :episode_title
  #default_scope :order => 'location, episode_number'

  attr_accessible :id, :created_at, :updated_at, :in_playlists, :active, :video_id, :episode_title, :episode_number,
                  :remarks, :remarks_other, :location

  attr_protected :id

  def before_save
    self.episode_title = self.episode_title.upcase    
  end
  
end
