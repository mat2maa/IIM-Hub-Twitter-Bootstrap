class CreateVoDurations < ActiveRecord::Migration
  def self.up
    add_column :audio_playlist_tracks, :vo_duration, :string
		
    create_table :vo_durations do |t|
      t.string :name
      t.string :duration
      t.timestamps
    end
		
		remove_column :tracks, :origin
  end

  def self.down
    remove_column :audio_playlist_tracks, :vo_duration
		add_column :tracks, :origin, :string
		drop_table :vo_durations
  end

end
