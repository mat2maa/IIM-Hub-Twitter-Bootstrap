# Remember to delete first row if it contains column headers
require 'csv'
require 'logger'

namespace :db do
  task :update_masters => :environment do
    logger = Logger.new STDOUT 
            
    CSV.foreach("import/masters.csv") do |row|
      
      if !row[0].nil?

        puts row[0]
          
        master = Master.find(row[0])
        if !master.nil?
          master.video.programme_title = row[1]
      		master.video.video_type = row[2]
      		master.episode_title = row[3] 
      		master.episode_number = row[4]
    
      		master.save(false)
  	    end
      end
    end 
  end 
end