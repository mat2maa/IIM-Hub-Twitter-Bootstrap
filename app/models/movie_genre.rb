class MovieGenre < ActiveRecord::Base
  has_and_belongs_to_many :movies, :order => 'name ASC'
  validates_presence_of :name
end
