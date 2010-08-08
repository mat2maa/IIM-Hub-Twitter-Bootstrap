class AddMasterAspectRatio < ActiveRecord::Migration
  def self.up
    add_column :masters, :aspect_ratio, :string
  end

  def self.down
    remove_column :masters, :aspect_ratio
  end
end
