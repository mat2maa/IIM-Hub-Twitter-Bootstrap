class ArchiveWhenDeleting < ActiveRecord::Migration
  def self.up
    add_column :movies, :active, :boolean
    add_column :videos, :active, :boolean
    add_column :screeners, :active, :boolean
    add_column :masters, :active, :boolean
  end

  def self.down
    remove_column :movies, :active, :boolean
    remove_column :videos, :active, :boolean
    remove_column :screeners, :active, :boolean
    remove_column :masters, :active, :boolean
  end
end
