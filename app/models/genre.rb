class Genre < ActiveRecord::Base
  has_and_belongs_to_many :albums, :order => 'name ASC'
  has_and_belongs_to_many :tracks, :order => 'name ASC'
end
