class Publisher < ActiveRecord::Base
  has_many :albums

  attr_accessible :name

end
