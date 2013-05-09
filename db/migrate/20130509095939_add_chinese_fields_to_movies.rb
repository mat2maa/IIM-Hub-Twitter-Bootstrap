class AddChineseFieldsToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :chinese_movie_title, :string
    add_column :movies, :chinese_cast, :text
    add_column :movies, :chinese_director, :string
    add_column :movies, :chinese_synopsis, :text
  end
end
