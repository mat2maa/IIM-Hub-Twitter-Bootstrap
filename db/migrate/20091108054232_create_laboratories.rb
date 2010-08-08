class CreateLaboratories < ActiveRecord::Migration
  def self.up
    create_table :laboratories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :laboratories
  end
end
