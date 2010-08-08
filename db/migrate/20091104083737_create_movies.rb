class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :movie_title
      t.string :foreign_language_title
      t.string :movie_type
      t.integer :movie_distributor_id
      t.integer :production_studio_id
      t.integer :laboratory_id
      t.integer :theatrical_release_year
      t.date :airline_release_date
      t.date :personal_video_date
      t.integer :theatrical_runtime
      t.integer :edited_runtime
      t.string :rating
      t.text :cast
      t.string :director
      t.text :synopsis
      t.text :critics_review
      t.string :airline_rights
      t.date :screener_received_date
      t.date :screener_destroyed_date
      t.string :screener_remarks
      t.string :screener_remarks_other
      t.boolean :to_delete
  
      t.timestamps
    end
    
    add_index :movies, :movie_distributor_id
    add_index :movies, :production_studio_id
    add_index :movies, :laboratory_id
    
  end

  def self.down
    drop_table :movies
    
    remove_index :movies, :movie_distributor_id
    remove_index :movies, :production_studio_id
    remove_index :movies, :laboratory_id
    
  end
end
