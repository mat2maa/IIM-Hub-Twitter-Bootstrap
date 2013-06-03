class AddGappNumberToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :gapp_number, :string
  end
end
