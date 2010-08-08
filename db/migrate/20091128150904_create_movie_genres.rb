class CreateMovieGenres < ActiveRecord::Migration
  def self.up
    create_table :movie_genres do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :movie_genres
  end
end
