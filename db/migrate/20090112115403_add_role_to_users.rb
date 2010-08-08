class AddRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :roles, :text
    add_column :audio_playlists, :program_cache, :string
    add_column :audio_playlists, :airline_cache, :string
    add_column :tracks, :label, :string
    add_column :tracks, :language, :string
    add_column :tracks, :origin, :string
    add_column :tracks, :genres, :text   
  end

  def self.down
    remove_column :users, :roles
    remove_column :audio_playlists, :program_cache, :default=>'', :null=>false
    remove_column :audio_playlists, :airline_cache, :default=>'', :null=>false
    remove_column :tracks, :label_cache
    remove_column :tracks, :language_cache
    remove_column :tracks, :origin_cache
    remove_column :tracks, :genres_cache
  end
end
