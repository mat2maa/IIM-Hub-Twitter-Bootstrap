# Remember to delete first row if it contains column headers
require 'nokogiri'
require 'logger'

namespace :db do
  task :import_video_playlists => :environment do
    logger = Logger.new STDOUT

    logger.debug 'Importing Video Playlists'
        
    f = File.open("import/video_playlists.xml")
    doc = Nokogiri::XML(f)
    f.close
    
    old_playlists = doc.xpath('//xmlns:ROW')
    
    VideoPlaylist.destroy_all
    
    old_playlists.each do |old_playlist|
      
      new_playlist = VideoPlaylist.new
      new_playlist.id = old_playlist.css("Play_List_No").text
      puts new_playlist.id
      
      airline = Airline.find_by_name(old_playlist.css("Airline").text)
      new_playlist.airline_id = airline.id if !airline.nil?
      
      playdate = old_playlist.css("Play_Date").text.split('-')
      
      if !playdate[0].nil?
        start_date = playdate[0].split(' ') 
        the_date = DateTime.parse(start_date[0] + '20' + start_date[1] ) if !start_date[1].nil? && !start_date[0].nil?
        new_playlist.start_cycle = the_date.strftime('%Y-%m-01') if !the_date.nil?
        
      end

      if !playdate[1].nil?
        end_date = playdate[1].split(' ')
        the_date = DateTime.parse(end_date[0] + '20' + end_date[1] ) if !end_date[1].nil? && !end_date[0].nil?
        new_playlist.end_cycle = the_date.strftime('%Y-%m-01') if !the_date.nil?
      end
      
      
      #replace IIM_Video_Database.Record_ID with Record_ID
      old_playlist_items = old_playlist.css("DATA")
      
      i = 1
      
      old_playlist_items.each do |old_playlist_item|
        VideoPlaylistItem.create( 
        :video_playlist_id => new_playlist.id, 
        :video_id => old_playlist_item.text.to_i, 
        :position => i)
        
        i = i + 1
        
      end
      
      new_playlist.save(false)
      
    end
    
  end
end