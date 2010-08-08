class Category < ActiveRecord::Base
  has_many :album_playlist_items
  has_many :origins
end
