class CreateMoviesAirlineRightsCountries < ActiveRecord::Migration
  def self.up
    create_table :airline_rights_countries_movies, :id => false, :force => true do |t|
      t.integer :airline_rights_country_id
      t.integer :movie_id

      t.timestamps
    end
  end

  def self.down
    drop_table :airline_rights_countries_movies
  end
end
