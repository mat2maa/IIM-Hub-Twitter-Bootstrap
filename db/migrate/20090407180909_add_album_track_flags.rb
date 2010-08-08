class AddAlbumTrackFlags < ActiveRecord::Migration
  def self.up
    add_column :albums, :mp3_exists, :boolean, :default => 0
    add_column :tracks, :mp3_exists, :boolean, :default => 0
  end

  def self.down
    remove_column :albums, :mp3_exists, :boolean, :default => 0
    remove_column :tracks, :mp3_exists, :boolean, :default => 0
  end
end
