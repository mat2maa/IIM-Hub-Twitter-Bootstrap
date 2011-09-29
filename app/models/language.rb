class Language < ActiveRecord::Base
  validates_presence_of :name

  has_many :tracks, :order => 'name ASC'
  has_many :albums, :order => 'name ASC'
  
end
