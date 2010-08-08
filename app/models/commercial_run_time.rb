class CommercialRunTime < ActiveRecord::Base
  has_and_belongs_to_many :videos
  
  validates_presence_of :minutes
end