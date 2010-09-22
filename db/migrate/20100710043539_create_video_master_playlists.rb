class CreateVideoMasterPlaylists < ActiveRecord::Migration
  def self.up
    create_table :video_master_playlists do |t|
      t.integer :airline_id
      t.date :start_cycle
      t.date :end_cycle
      t.integer :user_id
      t.boolean :locked, :default=>false, :null=>false

      t.timestamps
    end
    add_index :video_master_playlists, :airline_id
    
  end

  def self.down
    drop_table :video_master_playlists
  end
end