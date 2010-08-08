class CreateAirlineRightsCountries < ActiveRecord::Migration
  def self.up
    create_table :airline_rights_countries do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :airline_rights_countries
  end
end
