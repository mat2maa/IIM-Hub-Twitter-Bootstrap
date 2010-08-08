class CreateVideoPlaylists < ActiveRecord::Migration
  def self.up
    create_table :video_playlists do |t|
      t.integer :airline_id
      t.date :start_cycle
      t.date :end_cycle
      t.integer :user_id
      t.boolean :locked, :default=>false, :null=>false

      t.timestamps
    end
    add_index :video_playlists, :airline_id
  end

  def self.down
    remove_index :video_playlists, :airline_id  
    drop_table :video_playlists
  end
end
