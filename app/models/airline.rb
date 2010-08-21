class Airline < ActiveRecord::Base
  default_scope :order => 'name'

  has_many :audio_playlists, :order => 'name ASC'
  has_many :album_playlists, :order => 'name ASC'
	
	def self.all_cached
		Rails.cache.fetch('Airline.all'){all}
	end
	
	def all
		self.find(:all)
	end
end
