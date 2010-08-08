class CreateCovers < ActiveRecord::Migration
  def self.up
    create_table :covers do |t|
      t.integer :album_id
      t.integer :parent_id
      t.integer :size
      t.integer :width
      t.integer :height
      t.string :content_type
      t.string :filename
      t.string :thumbnail

      t.timestamps
    end
  end

  def self.down
    drop_table :covers
  end
end
