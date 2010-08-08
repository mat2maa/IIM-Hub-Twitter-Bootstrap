class AddVideoGenreVideo < ActiveRecord::Migration
  def self.up
    create_table :video_genres_videos, :id => false, :force => true do |t|
      t.integer :video_genre_id
      t.integer :video_id

      t.timestamps
    end
  end

  def self.down
    drop_table :video_genres_videos
  end
end
