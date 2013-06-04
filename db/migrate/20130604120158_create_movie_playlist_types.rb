class CreateMoviePlaylistTypes < ActiveRecord::Migration
  def change
    create_table :movie_playlist_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
