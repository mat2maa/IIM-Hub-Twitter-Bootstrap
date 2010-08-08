class AddAirlineCountryRights < ActiveRecord::Migration
  def self.up
    add_column :movies, :airline_countries, :text
  end

  def self.down
    remove_column :movies, :airline_countries
  end
end
