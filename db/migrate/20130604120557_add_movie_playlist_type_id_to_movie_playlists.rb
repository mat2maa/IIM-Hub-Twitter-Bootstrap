class AddMoviePlaylistTypeIdToMoviePlaylists < ActiveRecord::Migration
  def self.up
    add_column :movie_playlists, :movie_playlist_type_id, :integer
    execute "UPDATE movie_playlists m, movie_playlist_types t SET m.movie_playlist_type_id = t.id WHERE m.movie_type = t.name"
    remove_column :movie_playlists, :movie_type
  end

  def self.down
    add_column :movie_playlists, :movie_type, :string
    execute "UPDATE movie_playlists m, movie_playlist_types t SET m.movie_type = t.name WHERE m.movie_playlist_type_id = t.id"
    remove_column :movie_playlists, :movie_playlist_type_id
  end
end
