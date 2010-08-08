class AddVideoOnGoingSeries < ActiveRecord::Migration
  def self.up
    add_column :videos, :on_going_series, :boolean
  end

  def self.down
    remove_column :videos, :on_going_series  
  end
end
