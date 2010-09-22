class AddTotalRuntimeToMasterplaylist < ActiveRecord::Migration
  def self.up
    add_column :video_master_playlists, :total_runtime, :string
    add_column :video_master_playlists, :edit_runtime, :string
    add_column :video_master_playlists, :media_instruction, :text
    add_column :video_master_playlists, :video_playlist_type_id, :integer
  end

  def self.down
    remove_column :video_master_playlists, :total_runtime
    remove_column :video_master_playlists, :edit_runtime
    remove_column :video_master_playlists, :media_instruction
    remove_column :video_master_playlists, :video_playlist_type_id
  end
end
