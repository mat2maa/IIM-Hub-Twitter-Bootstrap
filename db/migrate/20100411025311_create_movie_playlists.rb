class CreateMoviePlaylists < ActiveRecord::Migration
  def self.up
    create_table :movie_playlists do |t|
      t.integer :airline_id
      t.date :start_cycle
      t.date :end_cycle
      t.integer :user_id
      t.boolean :locked, :default=>false, :null=>false

      t.timestamps
    end
    add_index :movie_playlists, :airline_id
  end

  def self.down
    remove_index :movie_playlists, :airline_id
    drop_table :movie_playlists
  end
end
