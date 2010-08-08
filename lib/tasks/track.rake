#additional populate
require 'logger'
namespace :db do
	desc "Create populate cache for tracks"
  task :track => :environment do
    
    @tracks = Track.find(:all)
    logger = Logger.new STDOUT 
    
    @tracks.each do |track|
      logger.debug "track id:" + track.id.to_s
      if !track.album.label_id.nil? 
        logger.debug "label:" + track.album.label.name
        track.label_cache = track.album.label.name 
        
      end
      if !track.language_id.nil?
          logger.debug "language" + track.language.name
          track.language_cache = track.language.name 
      end
      
      if !track.origin_id.nil?
          logger.debug "origin" + track.origin.name
          track.origin_cache = track.origin.name 
      end
      
        track.save
    end
    
	end
	
end
