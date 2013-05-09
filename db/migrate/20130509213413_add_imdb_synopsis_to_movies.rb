class AddImdbSynopsisToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :imdb_synopsis, :text
  end
end
