class AddSplit < ActiveRecord::Migration
  def self.up
    add_column :audio_playlist_tracks, :split, :string
  end

  def self.down
    remove_column :audio_playlist_tracks, :split
  end
end
