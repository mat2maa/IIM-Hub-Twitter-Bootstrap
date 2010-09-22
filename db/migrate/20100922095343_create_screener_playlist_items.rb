class CreateScreenerPlaylistItems < ActiveRecord::Migration
  def self.up
    create_table :screener_playlist_items do |t|
        t.integer :screener_playlist_id
        t.integer :screener_id
  	    t.integer :position
  	    t.text :mastering
        t.timestamps
    end
    add_index :screener_playlist_items, :screener_playlist_id
    add_index :screener_playlist_items, :screener_id
    
  end

  def self.down
    remove_index :screener_playlist_items, :screener_playlist_id
    remove_index :screener_playlist_items, :screener_id

    drop_table :screener_playlist_items
  end
end
