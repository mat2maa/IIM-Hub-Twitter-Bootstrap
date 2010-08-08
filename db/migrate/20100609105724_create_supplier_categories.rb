class CreateSupplierCategories < ActiveRecord::Migration
  def self.up
    create_table :supplier_categories do |t|
      t.string :name
      t.string :remarks
      
      t.timestamps
    end
    drop_table :movie_distributors
    drop_table :video_distributors
    drop_table :laboratories
    drop_table :production_studios
  end

  def self.down
    drop_table :supplier_categories
  end
end
