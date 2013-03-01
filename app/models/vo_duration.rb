class VoDuration < ActiveRecord::Base
  validates_presence_of :name, :duration
  validates_numericality_of :duration

  attr_accessible :name, :duration
end
