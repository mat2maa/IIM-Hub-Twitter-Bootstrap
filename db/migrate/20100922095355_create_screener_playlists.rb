class CreateScreenerPlaylists < ActiveRecord::Migration
  def self.up
    create_table :screener_playlists do |t|
      t.integer :airline_id
      t.date :start_cycle
      t.date :end_cycle
      t.integer :user_id
      t.string :total_runtime
      t.string :edit_runtime
      t.text :media_instruction
      t.boolean :locked, :default=>false, :null=>false
      t.integer :video_playlist_type_id

      t.timestamps
    end
    add_index :screener_playlists, :airline_id
  end

  def self.down
    drop_table :screener_playlists
  end
end
