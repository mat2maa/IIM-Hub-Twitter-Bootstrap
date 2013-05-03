class Screener < ActiveRecord::Base

  belongs_to :video, :counter_cache => true
  validates_presence_of :episode_title
  #default_scope :order => 'location, episode_number'

  attr_accessible :id, :created_at, :updated_at, :in_playlists, :active, :video_id, :episode_title, :episode_number,
                  :remarks, :remarks_other, :location

  attr_protected :id

  scope :with_language_track, -> language_track {
    where("language_tracks like ?", "%#{language_track}%")
  }

  scope :with_language_subtitle, -> language_subtitle {
    where("language_subtitles like ?", "%#{language_subtitle}%")
  }

  def before_save
    self.episode_title = self.episode_title.upcase    
  end
  
end
