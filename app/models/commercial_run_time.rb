class CommercialRunTime < ActiveRecord::Base
  default_scope :order => 'minutes'
  
  has_and_belongs_to_many :videos
  
  validates_presence_of :minutes
end