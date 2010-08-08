class AddGenre < ActiveRecord::Migration
  def self.up
    add_column :albums, :genre, :string, :default => "", :null => false
    add_column :tracks, :genre, :string, :default => "", :null => false
  end

  def self.down
    remove_column :albums, :genre
    remove_column :tracks, :genre
  end
end
