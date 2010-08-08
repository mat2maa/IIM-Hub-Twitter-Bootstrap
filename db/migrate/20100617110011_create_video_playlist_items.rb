class CreateVideoPlaylistItems < ActiveRecord::Migration
  def self.up
    create_table :video_playlist_items do |t|
        t.integer :video_playlist_id
        t.integer :video_id
  	    t.integer :position
        t.timestamps
    end
    add_index :video_playlist_items, :video_playlist_id
    add_index :video_playlist_items, :video_id
  end

  def self.down
    remove_index :video_playlist_items, :video_playlist_id
    remove_index :video_playlist_items, :video_id
    
    drop_table :video_playlist_items
  end
end
