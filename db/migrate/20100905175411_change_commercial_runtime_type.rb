class ChangeCommercialRuntimeType < ActiveRecord::Migration
  def self.up
    change_column :commercial_run_times, :minutes, :integer
    change_column :masters, :episode_number, :string
    change_column :screeners, :episode_number, :string
    add_column :videos, :masters_count, :integer, :default => 0
    add_column :videos, :screeners_count, :integer, :default => 0
    
    Video.all.each do |video|
      Video.update_counters video.id, :masters_count => video.masters.count
      Video.update_counters video.id, :screeners_count => video.screeners.count
    end
  end

  def self.down
    change_column :commercial_run_times, :minutes, :string
    change_column :masters, :episode_number, :integer
    change_column :screeners, :episode_number, :integer
    remove_column :videos, :screeners_count
    remove_column :videos, :masters_count    
  end
end
