class VideoGenre < ActiveRecord::Base
  has_and_belongs_to_many :videos, :order => 'name ASC'
  belongs_to :video_parent_genre
  
  validates_presence_of :name
end
