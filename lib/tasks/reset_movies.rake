#additional populate
require 'logger'
namespace :db do
	desc "Reset the in_playlists column in movies"
  task :reset_movies => :environment do
    
    logger = Logger.new STDOUT 
    
    Movie.find_each do |movie|
      logger.debug "movie id:" + movie.id.to_s
        movie.in_playlists = MoviePlaylist.find(:all,
          :conditions => "movies.id=#{movie.id}", 
          :include => "movies").collect{|playlist| playlist.id}.join(',')
        movie.save(false)
    end
	end
end
