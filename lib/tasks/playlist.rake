#additional populate
require 'logger'
namespace :db do
	desc "Create populate cache for audio playlist"
  task :playlist => :environment do
    
    @playlists = AudioPlaylist.find(:all)
    logger = Logger.new STDOUT 
    
    @playlists.each do |playlist|
      logger.debug "playlist id:" + playlist.id.to_s
      if !playlist.program_id.nil? 
        logger.debug "program:" + playlist.program.name
        playlist.program_cache = playlist.program.name 
        
      end
      if !playlist.airline_id.nil?
        if Airline.exists?(playlist.airline_id)
          logger.debug "airline" + playlist.airline.name
          playlist.airline_cache = playlist.airline.name 
        else
          playlist.airline_id = nil
        end
      end
        playlist.save
    end
    
	end
	
end
