class AddMovieTypeIdToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :movie_type_id, :integer
    execute "UPDATE movies m, movie_types t SET m.movie_type_id = t.id WHERE m.movie_type = t.name"
    remove_column :movies, :movie_type
  end

  def self.down
    add_column :movies, :movie_type, :string
    execute "UPDATE movies m, movie_types t SET m.movie_type = t.name WHERE m.movie_type_id = t.id"
    remove_column :movies, :movie_type_id
  end
end