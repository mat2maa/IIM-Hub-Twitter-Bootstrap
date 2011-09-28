class ArchiveWhenDeleting < ActiveRecord::Migration
  def self.up
    add_column :movies, :active, :boolean, :default => true
    add_column :videos, :active, :boolean, :default => true
    add_column :screeners, :active, :boolean, :default => true
    add_column :masters, :active, :boolean, :default => true
  end

  def self.down
    remove_column :movies, :active
    remove_column :videos, :active
    remove_column :screeners, :active
    remove_column :masters, :active
  end
end
