class CreateVideoPlaylistTypes < ActiveRecord::Migration
  def self.up
    create_table :video_playlist_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :video_playlist_types
  end
end
