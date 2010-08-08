class CreateVideoParentGenres < ActiveRecord::Migration
  def self.up
    create_table :video_parent_genres do |t|
      t.string :name
      t.timestamps
    end
    
    add_column :video_genres, :video_parent_genre_id, :integer
    add_index :video_genres, :video_parent_genre_id
    
  end

  def self.down
    drop_table :video_parent_genres
    remove_column :masters, :video_parent_genre_id
    remove_index :video_genres, :video_parent_genre_id
  end
    
end
