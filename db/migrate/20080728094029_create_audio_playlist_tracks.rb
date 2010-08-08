class CreateAudioPlaylistTracks < ActiveRecord::Migration
  def self.up
    create_table :audio_playlist_tracks do |t|
	
      t.integer :audio_playlist_id
      t.integer :track_id
	    t.integer :position
	    t.text :mastering

      t.timestamps
    end
	
	  add_index :audio_playlist_tracks, :audio_playlist_id
    add_index :audio_playlist_tracks, :track_id
	
  end

  def self.down
    drop_table :audio_playlist_tracks
  end
end
