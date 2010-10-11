class AddVideoTypeToVideoPlaylist < ActiveRecord::Migration
  def self.up
    add_column :video_playlists, :video_playlist_type_id, :integer
    add_column :video_master_playlists, :master_playlist_type_id, :integer
    remove_column :video_master_playlists, :video_playlist_type_id
  end

  def self.down
    add_column :video_master_playlists, :video_playlist_type_id, :integer
    remove_column :video_master_playlists, :master_playlist_type_id
    remove_column :video_playlists, :video_playlist_type_id
  end
end
