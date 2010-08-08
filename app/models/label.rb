class Label < ActiveRecord::Base
  has_many :albums
    
  def self.all_cached
    Rails.cache.fetch('Label.all') { all }
  end
  
  def self.all
    self.find(:all)
  end
  
end
