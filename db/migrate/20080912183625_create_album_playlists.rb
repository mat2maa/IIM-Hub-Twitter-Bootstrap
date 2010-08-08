class CreateAlbumPlaylists < ActiveRecord::Migration
  def self.up
    create_table :album_playlists do |t|
      t.string :client_playlist_code
      t.integer :airline_id
      t.string :in_out
      t.date :start_playdate
      t.date :end_playdate
      t.integer :user_id
      t.boolean :locked

      t.timestamps
    end
  end

  def self.down
    drop_table :album_playlists
  end
end
