class AddTrackExplicit < ActiveRecord::Migration
  def self.up
    add_column :tracks, :explicit_lyrics, :boolean, :default => 0 
  end

  def self.down
    remove_column :tracks, :explicit_lyrics
  end
end
