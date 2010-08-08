class AddAlbumTotalDuration < ActiveRecord::Migration
  def self.up
    add_column :albums, :total_duration, :integer
    add_column :albums, :total_tracks, :integer
  end

  def self.down
    remove_column :albums, :total_duration
    remove_column :albums, :total_tracks
  end
end
