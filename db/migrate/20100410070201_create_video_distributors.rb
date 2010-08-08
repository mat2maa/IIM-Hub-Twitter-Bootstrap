class CreateVideoDistributors < ActiveRecord::Migration
  def self.up
    create_table :video_distributors do |t|
      t.string :name

      t.timestamps
    end
    rename_column :videos, :movie_distributor_id, :video_distributor_id
    add_index :videos, :video_distributor_id
    
  end

  def self.down
    remove_index :videos, :video_distributor_id
    drop_table :video_distributors
    rename_column :videos,:video_distributor_id, :movie_distributor_id
    
  end
end
