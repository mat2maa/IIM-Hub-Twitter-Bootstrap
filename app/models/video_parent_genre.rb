class VideoParentGenre < ActiveRecord::Base
  has_many :video_genres, :order => 'name ASC'  
  validates_presence_of :name
end
