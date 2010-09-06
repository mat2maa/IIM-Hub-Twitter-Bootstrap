class Screener < ActiveRecord::Base

  belongs_to :video, :counter_cache => true
  validates_presence_of :episode_title
  default_scope :order => 'location, episode_number'

end
