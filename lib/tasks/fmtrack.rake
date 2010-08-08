#additional populate
require 'logger'
namespace :db do
	desc "Create populate cache for tracks"
  task :fmtrack => :environment do
    
    @fm_tracks = FilemakerTrack.find(:all, :conditions=>"language != '' AND language != 'c' ")
    logger = Logger.new STDOUT 
    
    @fm_tracks.each do |fm_track|
      logger.debug "fm_track id:" + fm_track.id.to_s
			
      if !fm_track.language.nil? && fm_track.language!='' 
      
				track = Track.find(fm_track.id)
				track.language = fm_track.language
				language = Language.find(:first, :conditions=>{:name=>fm_track.language})
				track.language_id = language.id				
				track.save
     end
        
    end
    
	end
	
end
