class Origin < ActiveRecord::Base
  has_many :tracks
  has_many :albums

  attr_accessible :name

end
