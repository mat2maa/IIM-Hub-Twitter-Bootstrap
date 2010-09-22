class AddSecondSubtitleMasters < ActiveRecord::Migration
  def self.up
    add_column :masters, :video_subtitles_2, :string
    rename_column :masters, :video_subtitles, :video_subtitles_1
  end

  def self.down
    remove_column :masters, :video_subtitles_2, :string
    rename_column :masters, :video_subtitles_1, :video_subtitles
  end
end
