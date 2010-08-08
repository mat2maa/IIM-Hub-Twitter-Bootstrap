module GenresHelper

  def show_genres genres
    s = ""
	i = 1
    genres.each do |g| 
	  if i == 1
	    s = g.name
	  else
        s = s + ", " + g.name 
      end
	  i += 1
    end
	
    s
  end
  
end
