class CreateSplits < ActiveRecord::Migration
  def self.up
    create_table :splits do |t|
      t.string :name
      t.string :duration
      t.integer :more_than
      t.integer :less_than

      t.timestamps
    end
  end

  def self.down
    drop_table :splits
  end
end
