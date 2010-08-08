#additional populate
require 'logger'
namespace :db do
	desc "Delete and populate users and rights"
  task :genre => :environment do
    logger = Logger.new STDOUT 
     
    def get_genres genres
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
    
    @albums = Album.find(:all)
    @albums.each do |album|
      album.genre = get_genres(album.genres)
      album.save
      logger.debug "album " + album.id.to_s
      
    end
    
    @tracks = Track.find(:all)
    @tracks.each do |track|
      track.genre = get_genres(track.genres)
      track.save
      logger.debug "track " + track.id.to_s
      
    end
			
	end
end
