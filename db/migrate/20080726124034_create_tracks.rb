class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.integer :album_id
      t.string :title_english
      t.string :title_original
      t.string :artist_english
      t.string :artist_original
      t.string :composer
      #t.string :publisher
      t.string :distributor
      #t.text :description
      #t.text :info
      t.integer :duration
      t.string :ending
      t.string :tempo_intro
      t.string :tempo_outro
      t.string :tempo
      t.integer :track_num
      t.text :lyrics
      t.integer :language_id
      t.string :gender
      #t.string :program_type
      t.integer :origin_id
      t.boolean :to_delete, :default=>0, :null=>false;

      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
