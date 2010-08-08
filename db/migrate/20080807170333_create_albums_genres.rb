class CreateAlbumsGenres < ActiveRecord::Migration
  def self.up
    create_table :albums_genres, :id => false, :force => true do |t|
      t.integer :genre_id
      t.integer :album_id

      t.timestamps
    end
  end

  def self.down
    drop_table :albums_genres
  end
end
