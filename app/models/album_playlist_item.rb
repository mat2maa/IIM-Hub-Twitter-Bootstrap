class AlbumPlaylistItem < ActiveRecord::Base
  include RankedModel
  ranks :position, with_same: :album_playlist_id

  belongs_to :album_playlist
  belongs_to :album
#  acts_as_list :scope => :album_playlist
  belongs_to :category

  attr_accessible :category_id, :album_playlist_id, :album_id, :position
end
