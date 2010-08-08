class AlbumPlaylistItem < ActiveRecord::Base
  belongs_to :album_playlist
  belongs_to :album
  acts_as_list :scope => :album_playlist 
  belongs_to :category
end
