class AddGenderToAlbum < ActiveRecord::Migration
  def self.up
    add_column :albums, :language_id, :integer
    add_column :albums, :gender, :string
    add_column :albums, :origin_id, :integer
    
  end

  def self.down
    remove_column :albums, :language_id
    remove_column :albums, :gender
    remove_column :albums, :origin
    remove_column :tracks, :language
    remove_column :tracks, :origin
  end
end
