class AddMoviePlaylistCache < ActiveRecord::Migration
  def self.up
    add_column :movies, :in_playlists, :string
  end

  def self.down
    remove_column :movies, :in_playlists
  end
end
