class CreateVos < ActiveRecord::Migration
  def self.up
    create_table :vos do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :vos
  end
end
