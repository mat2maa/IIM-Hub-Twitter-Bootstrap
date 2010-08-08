module TracksHelper
  
  
  def track_has_genre?(track_genres, genre)
    
    result = false
    track_genres.each do |track_genre|
      if track_genre.id == genre
        result= true
      end
    end
    
    result
    
  end
  
  def gender
    gender = ['Male', 'Female', 'Group']
  end
  
  def duration_min ms
    sec = ms/1000
    min = sec/60
	  if min == 0 :  min = "0"
  	end
  	min
  end
  
  def duration_sec ms
    sec = ms/1000
    min = sec/60
	  sec = sec%60
  	if sec < 10 :  sec = "0#{sec}"
  	end 
  	if sec == 0 :  sec = "00"
  	end
  	sec
  end
  
  def show_tempo t
    Tempo.find(t)
  end
  
  def duration ms
    if !ms.nil?
  
      sec = ms/1000

      min = sec/60
  
      sec = sec%60

      if sec < 10 :  sec = "0#{sec}"
      end 
      if sec == 0 :  sec = "00"
      end
      if min == 0 :  min = "0"
      end

      t = "#{min}:#{sec}"
      else 
      t = "0:00"
    end
    t
  end
end