class AddVideoPlaylistCache < ActiveRecord::Migration
  def self.up
    add_column :videos, :in_playlists, :string
    add_column :screeners, :in_playlists, :string
    add_column :masters, :in_playlists, :string
  end

  def self.down
    remove_column :videos, :in_playlists
    remove_column :screeners, :in_playlists
    remove_column :masters, :in_playlists
  end
end
