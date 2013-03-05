class CommercialRunTime < ActiveRecord::Base
  validates_numericality_of :minutes
  default_scope :order => 'minutes'
  
  has_and_belongs_to_many :videos
  
  validates_presence_of :minutes

  attr_accessible :minutes
end