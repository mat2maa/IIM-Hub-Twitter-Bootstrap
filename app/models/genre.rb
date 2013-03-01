class Genre < ActiveRecord::Base
  has_and_belongs_to_many :albums, :order => 'name ASC'
  has_and_belongs_to_many :tracks, :order => 'name ASC'

  attr_accessible :name
end
