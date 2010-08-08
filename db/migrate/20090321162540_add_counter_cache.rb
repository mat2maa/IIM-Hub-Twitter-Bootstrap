class AddCounterCache < ActiveRecord::Migration
  def self.up
    add_column :albums, :tracks_count, :integer, :default => 0
    add_column :albums, :compilation, :boolean, :default => 0
    remove_column :albums, :total_tracks
    Album.reset_column_information    
  end

  def self.down
    remove_column :albums, :tracks_count
    remove_column :albums, :compilation
    add_column :albums, :total_tracks, :integer, :default => 0
  end
end
# update albums, (select album_id, count(*) as the_count from tracks group by album_id) as comm set albums.tracks_count = comm.the_count where albums.id = comm.album_id