class FixOrderInMoviePlaylists < ActiveRecord::Migration
  def up

    MoviePlaylist.all.each do | playlist |
      items = playlist.movie_playlist_items.order(:position)

      MoviePlaylistItem.transaction do
        items.each.with_index do | item, index |
          item.position = index
          item.save
        end
      end
    end
  end

  def down
  end
end
