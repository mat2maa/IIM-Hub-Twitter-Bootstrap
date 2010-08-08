class CreateAudioPlaylists < ActiveRecord::Migration
  def self.up
    create_table :audio_playlists do |t|
      t.string :client_playlist_code
      t.integer :airline_id
      t.string :in_out
      t.date :start_playdate
      t.date :end_playdate
	    t.integer :vo_id
	    t.text :mastering
      t.integer :user_id
      t.integer :program_id
      t.boolean :locked, :default=>false, :null=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :audio_playlists
  end
end
