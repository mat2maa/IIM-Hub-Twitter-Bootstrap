class PopulateMoviePlaylistTypes < ActiveRecord::Migration
  def up
    movie_playlist_types = MoviePlaylist.all.map(&:movie_type).uniq
    MoviePlaylistType.create(movie_playlist_types.map { |t| { name: t } })
  end

  def down
    MoviePlaylistType.delete_all
  end
end
