class Language < ActiveRecord::Base
  has_many :tracks, :order => 'name ASC'
  has_many :albums, :order => 'name ASC'
end
