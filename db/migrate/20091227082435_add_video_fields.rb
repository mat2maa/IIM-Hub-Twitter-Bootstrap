class AddVideoFields < ActiveRecord::Migration
  def self.up
    add_column :videos, :movie_id, :integer
    
    add_column :videos, :poster_file_name, :string
    add_column :videos, :poster_content_type, :string
    add_column :videos, :poster_file_size, :integer
    add_column :videos, :poster_updated_at, :datetime
    add_column :videos, :to_delete, :boolean, :default => 0 
    
    add_column :videos, :language_tracks, :string
    add_column :videos, :language_tracks_mask, :integer
    
    add_column :videos, :language_subtitles, :string
    add_column :videos, :language_subtitles_mask, :integer    
    
    add_index :videos, :video_type  
    add_index :videos, :video_distributor_id
    add_index :videos, :production_studio_id
    add_index :videos, :laboratory_id
    
  end

  def self.down
    remove_column :videos, :movie_id
    remove_column :videos, :poster_file_name
    remove_column :videos, :poster_content_type
    remove_column :videos, :poster_file_size
    remove_column :videos, :poster_updated_at
    remove_column :videos, :to_delete
    
    remove_column :videos, :language_tracks
    remove_column :videos, :language_tracks_mask
    
    remove_column :videos, :language_subtitles
    remove_column :videos, :language_subtitles_mask
  end
end

