class AddMovieGenreMovies < ActiveRecord::Migration
  def self.up
    create_table :movie_genres_movies, :id => false, :force => true do |t|
      t.integer :movie_genre_id
      t.integer :movie_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_genres_movies
  end
end
