class CreateMoviePlaylistItems < ActiveRecord::Migration
  def self.up
    create_table :movie_playlist_items do |t|
      t.integer :movie_playlist_id
      t.integer :movie_id
	    t.integer :position
      t.timestamps
    end
    add_index :movie_playlist_items, :movie_playlist_id
    add_index :movie_playlist_items, :movie_id
    
    change_column(:movies, :to_delete, :boolean, :default => 0)
  end

  def self.down
    drop_table :movie_playlist_items
  end
end
