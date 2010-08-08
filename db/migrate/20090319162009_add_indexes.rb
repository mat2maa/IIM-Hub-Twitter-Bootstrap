class AddIndexes < ActiveRecord::Migration
  def self.up
    #add_index :album_playlist_items, [:album_playlist_id]
    #add_index :audio_playlist_tracks, [:audio_playlist_id]
    add_index :covers, [:album_id, :parent_id]
    add_index :tracks, :album_id
  end

  def self.down
    #remove_index :album_playlist_items, [:album_playlist_id]
    #remove_index :audio_playlist_tracks, [:audio_playlist_id]
    remove_index :covers, [:album_id, :parent_id]
    remove_index :tracks, :album_id    
  end
end
