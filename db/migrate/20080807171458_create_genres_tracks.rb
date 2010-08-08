class CreateGenresTracks < ActiveRecord::Migration
  def self.up
    create_table :genres_tracks, :id => false, :force => true do |t|
      t.integer :genre_id
      t.integer :track_id

      t.timestamps
    end
  end

  def self.down
    drop_table :genres_tracks
  end
end
