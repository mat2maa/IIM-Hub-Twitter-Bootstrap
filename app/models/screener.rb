class Screener < ActiveRecord::Base

  belongs_to :video
  validates_presence_of :episode_title

end
