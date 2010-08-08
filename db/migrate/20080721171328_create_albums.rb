class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums  do |t|
      t.integer :label_id
      t.string :title_original
      t.string :title_english
      t.string :artwork
      t.string :cd_code
      t.integer :disc_num
      t.integer :disc_count
      t.integer :release_year
      t.string :artist_original
      t.string :artist_english
      t.text :synopsis
      t.integer :publisher_id
      t.boolean :live_album, :default => 0 
	    t.boolean :explicit_lyrics, :default => 0 
	    t.boolean :to_delete, :default => 0 

      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
