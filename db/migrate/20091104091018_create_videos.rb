class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :programme_title
      t.string :foreign_language_title
      t.string :video_type
      t.integer :video_distributor_id
      t.integer :production_studio_id
      t.integer :laboratory_id
      t.integer :production_year
      t.integer :runtime
      t.integer :episodes_available
      t.text :synopsis
      t.string :trailer_url
      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
