class VideoGenre < ActiveRecord::Base
  has_and_belongs_to_many :videos, :order => 'name ASC'
  belongs_to :video_parent_genre
  
  validates_presence_of :name

  attr_accessible :name, :video_parent_genre_id
end
