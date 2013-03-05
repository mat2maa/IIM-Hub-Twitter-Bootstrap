class AirlineRightsCountry < ActiveRecord::Base
  default_scope :order => 'name'
  
  has_and_belongs_to_many :movies
  
  validates_presence_of :name

  attr_accessible :name
end
