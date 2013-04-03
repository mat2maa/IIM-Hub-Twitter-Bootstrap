class MovieGenre < ActiveRecord::Base
  has_and_belongs_to_many :movies
  validates_presence_of :name

  attr_accessible :name
end
