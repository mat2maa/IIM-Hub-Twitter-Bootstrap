class AddAirlineDuration < ActiveRecord::Migration
  def self.up
    add_column :audio_playlists, :airline_duration, :string
  end

  def self.down
    remove_column :audio_playlists, :airline_duration
  end
end
