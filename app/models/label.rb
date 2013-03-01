class Label < ActiveRecord::Base
  has_many :albums

  attr_accessible :name
    
  def self.all_cached
    Rails.cache.fetch('Label.all') { all }
  end
  
  def self.all
    self.all
  end
  
end
