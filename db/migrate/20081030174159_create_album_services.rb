class CreateAlbumServices < ActiveRecord::Migration
  def self.up
    create_table :album_services do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :album_services
  end
end
