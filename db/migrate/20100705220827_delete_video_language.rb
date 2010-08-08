class DeleteVideoLanguage < ActiveRecord::Migration
  def self.up
    remove_column :videos, :language_subtitles
    remove_column :videos, :language_tracks
  end

  def self.down
    add_column :videos, :language_tracks, :string
    add_column :videos, :language_subtitles, :string
  end
end
