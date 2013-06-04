class MovieType < ActiveRecord::Base
  has_many :movies
  validates_presence_of :name
  
  attr_accessible :name
end
