class CreateCommercialRunTimes < ActiveRecord::Migration
  def self.up
    create_table :commercial_run_times do |t|
      t.string :minutes
      t.timestamps
    end
    
    remove_column :videos, :runtime
    add_column :videos, :commercial_run_time_id, :integer
    remove_column :videos, :video_distributor_id
    add_column :videos, :movie_distributor_id, :integer
    
  end

  def self.down
    drop_table :commercial_run_times
    remove_column :videos, :commercial_run_time_id
    add_column :videos, :runtime, :integer
    remove_column :videos, :movie_distributor_id
    add_column :videos, :video_distributor_id, :integer
  end
end
