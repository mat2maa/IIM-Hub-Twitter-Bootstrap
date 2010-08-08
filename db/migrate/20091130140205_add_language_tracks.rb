class AddLanguageTracks < ActiveRecord::Migration
  def self.up
    add_column :movies, :language_tracks, :string
    add_column :movies, :language_tracks_mask, :integer
    
    add_column :movies, :language_subtitles, :string
    add_column :movies, :language_subtitles_mask, :integer
    
    add_column :movies, :has_press_kit, :boolean
    add_column :movies, :has_poster, :boolean
    
  end

  def self.down
    remove_column :movies, :language_tracks
    remove_column :movies, :language_tracks_mask
    
    remove_column :movies, :language_subtitles
    remove_column :movies, :language_subtitles_mask
    
    remove_column :movies, :has_press_kit
    remove_column :movies, :has_poster
    
  end
end
