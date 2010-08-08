class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end
    # Make sure the role migration file was generated first
  	Category.create(:id => 1, :name => '')
  end

  def self.down
    drop_table :categories
  end
end
