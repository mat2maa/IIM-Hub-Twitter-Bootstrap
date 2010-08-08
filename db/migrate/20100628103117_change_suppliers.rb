class ChangeSuppliers < ActiveRecord::Migration
  def self.up
     change_column(:suppliers, :bank_branch, :text)
  end

  def self.down
  end
end
