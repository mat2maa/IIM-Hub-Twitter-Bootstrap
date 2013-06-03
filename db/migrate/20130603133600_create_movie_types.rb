class CreateMovieTypes < ActiveRecord::Migration
  def change
    create_table :movie_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
