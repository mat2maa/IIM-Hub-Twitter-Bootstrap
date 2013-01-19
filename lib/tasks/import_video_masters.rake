# Remember to delete first row if it contains column headers
require 'csv'
require 'logger'

namespace :db do
  task :import_video_masters => :environment do
    logger = Logger.new STDOUT 
        
    Video.destroy_all
    
    CSV.foreach("import/video_masters.csv") do |row|
      
      if !row[0].nil?

        puts row[0]
        
        if row[3].include?('Trailer') || row[3].include?('EPK')
          new_video = Video.find(:first, 
              :conditions => ["programme_title=? AND video_type LIKE ?", "#{row[1]}","%#{row[3]}%"])
        else
          new_video = Video.find_by_programme_title(row[1])
        end  
        
        if new_video.nil?
          new_video = Video.new
          if Video.find_by_id(row[0]).nil?
            new_video.id = row[0] #Record ID
          end
          new_video.programme_title = row[1] #Programme
  
          production_studio = Supplier.find_by_company_name(row[2]) #Movie Studio        
          new_video.production_studio = production_studio if !production_studio.nil? #Movie Studio

          if !row[3].nil? #Genre 
      		  video_genre = VideoGenre.find_by_name(row[3])
      			new_video.video_genres << video_genre if !video_genre.nil?
      		end
		
      		new_video.remarks = row[4] #Info
	
      	  movie = Movie.find_by_movie_title(row[1].upcase)
      	  if !movie.nil?
            if row[3].include?('Trailer')
              new_video.video_type = "Movie Trailer"
            else
              new_video.video_type = "Movie Master"
            end
        		new_video.synopsis = movie.synopsis
        		new_video.language_tracks = movie.language_tracks
        		new_video.language_subtitles = movie.language_subtitles
        		new_video.movie_id = movie.id
      		end     

      		if row[3].include?('Comedy') || row[3].include?('Sports') || row[3].include?('Documentary') || row[3].include?('Cartoon') || row[3].include?('Music Video') || row[3].include?('Stageshow') || row[3].include?('Sports')
            new_video.video_type = "Short Subject Programme"
          end   
        
          if row[3].include?('EPK')
            new_video.video_type = "Movie EPK"
          end
  		
      		if row[5].include?('TV SPECIAL')
            new_video.video_type = "TV Special"
          end   

        end
          
        master = Master.new
    		master.episode_title = row[5] #Episode Title
    		master.episode_number = row[6] #Episode#
    		master.location = row[7] #Tape #
    		master.time_in = row[8] #Time In
    		master.time_out = row[9] #Time Out
    		master.duration = row[10] #Duration
		
    		new_video.masters << master
    
    		new_video.save(false)
  	  
      end
    end 
  end 
end