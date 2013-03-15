class Role < ActiveRecord::Base
  #has_and_belongs_to_many :users
	has_and_belongs_to_many :rights
	validates_presence_of :name

  attr_accessible :name, :right_ids
  
end
