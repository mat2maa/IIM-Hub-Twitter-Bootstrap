class PopulateMovieTypes < ActiveRecord::Migration
  def up
    movie_types = Movie.all.map(&:movie_type).uniq
    MovieType.create(movie_types.map { |t| { name: t } })
  end

  def down
    MovieType.delete_all
  end
end
