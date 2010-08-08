class CreateAlbumPlaylistItems < ActiveRecord::Migration
  def self.up
    create_table :album_playlist_items do |t|
      t.integer :album_playlist_id
      t.integer :album_id
      t.integer :position
	    t.integer :category_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :album_playlist_items
  end
end
