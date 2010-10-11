class CreateMasterPlaylistTypes < ActiveRecord::Migration
  def self.up
    create_table :master_playlist_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :master_playlist_types
  end
end
