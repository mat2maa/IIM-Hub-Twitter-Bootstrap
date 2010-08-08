class AddMovieTypeToMoviePlaylist < ActiveRecord::Migration
  def self.up
    add_column :movie_playlists, :movie_type, :string
  end

  def self.down
    remove_column :movie_playlists, :movie_type
  end
end
