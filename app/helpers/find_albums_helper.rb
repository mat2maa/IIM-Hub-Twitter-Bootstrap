module FindAlbumsHelper

  def find_album_edit_links (playlist_id, album_id)
    l = ''
  	if !playlist_id.nil?
	  l =link_to_remote "add to playlist", :url => {:controller=> "album_playlists", :action => "add_album", :id => playlist_id, :album_id => album_id}

	end
	
	l

  end

end
