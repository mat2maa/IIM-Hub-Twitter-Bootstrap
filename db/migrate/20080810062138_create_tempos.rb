class CreateTempos < ActiveRecord::Migration
  def self.up
    create_table :tempos do |t|
      t.string :name

      t.timestamps
    end
	Tempo.create :name => "S"
	Tempo.create :name => "SM"
	Tempo.create :name => "M"
	Tempo.create :name => "MS"
	Tempo.create :name => "MF"
	Tempo.create :name => "F"
	Tempo.create :name => "VF"
  end

  def self.down
    drop_table :tempos
  end
end
