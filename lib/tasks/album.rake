#additional populate
require 'logger'
namespace :db do
	desc "UPdate total dur and tracks for albums"
  task :album => :environment do
    
    @albums = Album.find(:all)
    logger = Logger.new STDOUT 
    
    @albums.each do |album|
      logger.debug "album id:" + album.id.to_s
      
      album.total_tracks = album.tracks.count
      album.total_duration = album.duration
      album.save(validate: false)
      
    end
    
	end
	
end
