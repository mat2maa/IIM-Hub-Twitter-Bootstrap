class CreateProductionStudios < ActiveRecord::Migration
  def self.up
    create_table :production_studios do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :production_studios
  end
end
