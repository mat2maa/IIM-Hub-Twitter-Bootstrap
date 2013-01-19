# Remember to delete first row if it contains column headers
require 'nokogiri'
require 'logger'

namespace :db do
  task :import_movie_playlists => :environment do
    logger = Logger.new STDOUT

    logger.debug 'Importing Movie Playlists'
        
    f = File.open("import/movie_playlists.xml")
    doc = Nokogiri::XML(f)
    f.close
    
    old_playlists = doc.xpath('//xmlns:ROW')
    
    MoviePlaylist.destroy_all
    
    old_playlists.each do |old_playlist|
      
      new_playlist = MoviePlaylist.new
      new_playlist.id = old_playlist.css("Proposal_Number").text
      puts new_playlist.id
      
      airline = Airline.find_by_code(convert_airline_code(old_playlist.css("Airline_Code").text))
      new_playlist.airline_id = airline.id if !airline.nil?
      
      playdate = old_playlist.css("Playdate").text.split('-')
      
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
      
      new_playlist.created_at = old_playlist.css("Current_Date").text
      
      #replace IIM_Movie_Database.Record_ID with Record_ID
      old_playlist_items = old_playlist.css("DATA")
      
      i = 1
      
      old_playlist_items.each do |old_playlist_item|
        MoviePlaylistItem.create( 
        :movie_playlist_id => new_playlist.id, 
        :movie_id => old_playlist_item.text.to_i, 
        :position => i)
        
        i = i + 1
        
      end
      
      new_playlist.save(false)
      
    end
    
  end
  
  def convert_airline_code(code)
	  airline_code = case code
	    
      when 'XAX' then 'D7'
      when 'CCA' then 'CA'
      when 'MAU' then 'MK'
      when 'ANG' then 'PX'
      when 'VTA' then 'VT'
      when 'AAL' then 'AA'
      when 'AAR' then 'OZ'
      when 'BKP' then 'PG'
      when 'CSN' then 'CZ'
      when 'MSR' then 'MS'
      when 'ETD' then 'EY'
      when 'FIN' then 'AY'
      when 'GFA' then 'GF'
      when 'CHH' then 'HU'
      when 'HKE' then 'UO'
      when 'KAL' then 'KE'
      when 'MGL' then 'OM'
      when 'NWA' then 'NW'
      when 'OKA' then 'BK'
      when 'SVA' then 'SV'
      when 'CDG' then 'SC'
      when 'CSZ' then 'ZH'
      when 'CSC' then '3U'
      when 'SIA' then 'SQ'
      when 'ALK' then 'UL'
      when 'THA' then 'TG'
      when 'TAR' then 'TU'
      when 'HVN' then 'VN'
      when 'VRD' then 'VX'
      when 'VVM' then 'ZG'
      when 'WOA' then 'WO'
      when 'CWU' then 'WU'
	    
		  else code

	  end
	end
end