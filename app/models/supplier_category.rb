class SupplierCategory < ActiveRecord::Base
  has_and_belongs_to_many :suppliers
  
  #validates_presence_of :name, :remarks
  
  attr_accessible :name, :remarks
end
