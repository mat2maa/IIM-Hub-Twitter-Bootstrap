class CreateVideoGenres < ActiveRecord::Migration
  def self.up
    create_table :video_genres do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :video_genres
  end
end
