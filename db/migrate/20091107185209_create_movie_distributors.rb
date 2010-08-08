class CreateMovieDistributors < ActiveRecord::Migration
  def self.up
    create_table :movie_distributors do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_distributors
  end
end
