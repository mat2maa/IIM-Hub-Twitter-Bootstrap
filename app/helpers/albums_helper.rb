module AlbumsHelper
  def album_has_genre?(album_genres, genre)
    
    result = false
    album_genres.each do |album_genre|
      if album_genre.id == genre
        result= true
      end
    end
    
    result
    
  end
  
  def total_album_duration album
    t = 0

	album.tracks.each do |track|
	  t += track.duration/1000
	end
	
	duration_from_sec t
  end
  
  def has_explicit_lyrics e  	
    if e == true
	  e = 'yes'
	else
	  e = 'no'
	end  
	e
  end
  
  def cover_for(album, size = :medium) 
    if album.cover 
      cover_image = album.cover.public_filename(size) 
      link_to image_tag(cover_image), album.cover.public_filename 
    else 
      image_tag("blank-cover-#{size}.png") 
    end 
  end 
  
end

