class AddRemarksToVideo < ActiveRecord::Migration
  def self.up
    add_column :videos, :remarks, :text
    add_column :movies, :poster_quantity, :integer, :default => 0
    add_column :movies, :remarks, :text
    change_column :masters, :location, :integer
    remove_column :movies, :language_subtitles
    remove_column :movies, :language_tracks
  end

  def self.down
    remove_column :videos, :remarks
    remove_column :movies, :poster_quantity
    remove_column :movies, :remarks
    add_column :movies, :language_tracks, :string
    add_column :movies, :language_subtitles, :string
  end
end
