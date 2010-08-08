# Remember to delete first row if it contains column headers
require 'fastercsv'
require 'logger'

namespace :db do
  task :import_movies => :environment do
    logger = Logger.new STDOUT 
    
    images_path = 'import/movie_posters/'
    
    Movie.destroy_all
    
    FasterCSV.foreach("import/movies.csv") do |row|
      
      if !row[0].nil?

        puts row[0]
        
        distributor = Supplier.find_by_company_name(row[2]) #Movie Studio
        laboratory = Supplier.find_by_company_name(row[3]) #Lab
        
        movie = Movie.new
    		movie.id = row[0] #Record ID
    		movie.movie_title = row[1] #Title
    		movie.movie_distributor = distributor if !distributor.nil? #Movie Studio
    		movie.laboratory = laboratory if !laboratory.nil? #Lab
    		movie.airline_release_date = row[4] #English Only Date
      	
      	if row[5] == 'No' #Airline Edit
      	  movie.theatrical_runtime = row[6].chomp(':').to_i #Running Time
      	else
      	  movie.edited_runtime = row[6].chomp(':').to_i #Running Time
      	end
      	
    		movie.rating = row[7] #Rating
    		movie.cast = row[8] #Cast
    		movie.director = row[9] #Director  
    		movie.synopsis = row[10] #Synopsis
    		movie.airline_rights = row[11] #Rights
    	  movie.screener_received_date = row[12] if row[12]!="" #Screener In
    	  movie.screener_destroyed_date = row[13] if row[13]!="" #Screener Out

    		
    		screener_remarks = case row[14] #Screener Remarks
    		
  		    when 'DVD' then ["Other"]
  		    when 'Black & White' then ["DVD B&W"]
    		  when 'With Chinese Subtitles' then ["Other"]
    		  when 'With Japanese Subtitles' then ["Other"]
    		  else []
    		    
  		  end
    		
    		movie.screener_remarks = screener_remarks	  		

    		language_tracks = row[15].gsub(/\s*\(If Foreign Movie\)/, '').split(' ') #Dual Tracks
    		
    		language_tracks.each_index do |x|
    		  language_tracks[x] = convert_language(language_tracks[x])
  		  end
  		  
    		movie.language_tracks = language_tracks
    		  
    		language_subtitles = row[16].gsub(/\s*\(If Foreign Movie\)/, '').split(' ') #Subtitles
    		  		    		
    		language_subtitles.each_index do |x|
    		  language_subtitles[x] = convert_language(language_subtitles[x])
  		  end
  		  
    		movie.language_subtitles = language_subtitles
            		
    		movie.has_press_kit = row[17] #Promotional Kit
    		movie.remarks = row[18] #Movie Remarks  
    		
    		if !row[19].nil? #Genre
      		genres = row[19].gsub('/ ./', '').split("/") 
    		  
    		  genres.each do |genre|
      		  movie_genre = MovieGenre.find_by_name(genre)
      			movie.movie_genres << movie_genre if !movie_genre.nil?
      		end
    		end
    	
  		  if File.exists?(images_path + movie.id.to_s + '.jpg')
        
          f = File.open(images_path + movie.id.to_s + '.jpg')
          movie.poster = f
          f.close
          
        end
    		
    		movie.save(false)
    		
      end
    end 
  end  
  
  def convert_language(lang)
	  language = case lang

	    when 'MAN' then 'Zho'
	    when 'JAP' then 'Jpn'
	    when 'FRE' then 'Fra'
	    when 'ITA' then 'Ita'
	    when 'TUR' then 'Tur'
	    when 'CAN' then 'Yue'
	    when 'KOR' then 'Kor'
	    when 'GER' then 'Deu'
	    when 'RUS' then 'Rus'
	    when 'ENG' then 'Eng'
	    when 'ARB' then 'Ara'
		  else ''

	  end
	end
	
end