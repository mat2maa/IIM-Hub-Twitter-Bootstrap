class CreateVideoMasterPlaylistItems < ActiveRecord::Migration
  def self.up
    create_table :video_master_playlist_items do |t|
        t.integer :video_master_playlist_id
        t.integer :master_id
  	    t.integer :position
  	    t.text :mastering
        t.timestamps
    end
    add_index :video_master_playlist_items, :video_master_playlist_id
    add_index :video_master_playlist_items, :master_id
    
  end

  def self.down
    remove_index :video_master_playlist_items, :video_master_playlist_id
    remove_index :video_master_playlist_items, :master_id

    drop_table :video_master_playlist_items
  end
end
