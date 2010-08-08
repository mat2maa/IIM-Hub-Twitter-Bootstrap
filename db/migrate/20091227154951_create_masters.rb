class CreateMasters < ActiveRecord::Migration
  def self.up
    create_table :masters do |t|
      t.integer :video_id
      t.string :episode_title
      t.integer :episode_number
      t.string :tape_media
      t.string :tape_format
      t.string :tape_size
      t.string :language_track_1
      t.string :language_track_2
      t.string :language_track_3
      t.string :language_track_4
      t.string :video_subtitles
      t.string :location
      t.string :time_in
      t.string :time_out
      t.string :duration
      t.text :synopsis
      
      t.timestamps
    end
    add_index :masters, :video_id
  end

  def self.down
    drop_table :masters
  end
end