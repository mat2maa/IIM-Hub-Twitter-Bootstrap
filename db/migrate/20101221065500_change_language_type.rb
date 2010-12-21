class ChangeLanguageType < ActiveRecord::Migration
  def self.up
     change_column(:movies, :language_tracks, :text)
     change_column(:movies, :language_subtitles, :text)
     change_column(:videos, :language_tracks, :text)
     change_column(:videos, :language_subtitles, :text)
  end

  def self.down
    change_column(:movies, :language_tracks, :string)
    change_column(:movies, :language_subtitles, :string)
    change_column(:videos, :language_tracks, :string)
    change_column(:videos, :language_subtitles, :string)
  end
end
