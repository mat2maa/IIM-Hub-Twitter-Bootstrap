require "spreadsheet"
require 'stringio'

class AudioPlaylistsController < ApplicationController

  in_place_edit_for :audio_playlist_track, :mastering
  in_place_edit_for :audio_playlist_track, :split
  in_place_edit_for :audio_playlist_track, :vo_duration
  layout "layouts/application" ,  :except => :export_to_excel
  before_filter :require_user
  filter_access_to :all

  def index
    @search = AudioPlaylist.ransack(params[:q])
    if !params[:q].nil?
      @audio_playlists = @search.result(:distinct => true)
                                .paginate(page: params[:page], per_page: 10)
    else
      @audio_playlists = @search.result(:distinct => true)
                                .order("id DESC")
                                .paginate(page: params[:page], per_page: 10)
    end
    @audio_playlists_count = @audio_playlists.count
  end

  def show
    @audio_playlist = AudioPlaylist.find(params[:id]) 	 
  end

  def print

    @audio_playlist = AudioPlaylist.find(params[:id]) 	

    respond_to do  |format|
      format.html {render :layout => false }
    end
  end

  def sort

    params[:audioplaylist].each_with_index do |id, pos|
      AudioPlaylistTrack.find(id).update_attribute(:position, pos+1)
    end
    render :nothing => true
  end


  def new
    @audio_playlist = AudioPlaylist.new
  end

  def create

    @audio_playlist = AudioPlaylist.new(params[:audio_playlist])
    @audio_playlist.user_id = current_user.id

    if !@audio_playlist.program_id.nil?
      @audio_playlist.program_cache = @audio_playlist.program.name
    else
      @audio_playlist.program_cache = ''
    end
    if !@audio_playlist.airline_id.nil?
      @audio_playlist.airline_cache = @audio_playlist.airline.name
    else
      @audio_playlist.airline_cache = ''
    end

    respond_to do |format|
      if @audio_playlist.save
        flash[:notice] = 'Playlist was successfully created.'
        format.html { redirect_to(edit_audio_playlist_path(@audio_playlist)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit 
    @audio_playlist = AudioPlaylist.find(params[:id]) 	
  end 

  def update
    @audio_playlist = AudioPlaylist.find(params[:id])

    respond_to do |format|
      if @audio_playlist.update_attributes(params[:audio_playlist])
        if !@audio_playlist.program_id.nil?
          @audio_playlist.program_cache = @audio_playlist.program.name
        else
          @audio_playlist.program_cache = ''
        end
        if !@audio_playlist.airline_id.nil?
          @audio_playlist.airline_cache = @audio_playlist.airline.name
        else
          @audio_playlist.airline_cache = ''
        end
        @audio_playlist.save
        flash[:notice] = 'Playlist was successfully updated.'
        #format.html { redirect_to(audio_playlists_path) }

        #else
        format.html { render :action => "edit" }

      end
    end
  end

  def destroy
    @audio_playlist = AudioPlaylist.find(params[:id])
    @audio_playlist.destroy

    respond_to do |format|
      format.html { redirect_to(audio_playlists_path) }
      format.js
    end
  end

  def lock
    @audio_playlist = AudioPlaylist.find(params[:id])
    @audio_playlist.locked = true
    @audio_playlist.save

    respond_to do |format|
      flash[:notice] = 'Playlist was locked'
      format.html { redirect_to(audio_playlists_path) }
    end
  end

  def unlock
    @audio_playlist = AudioPlaylist.find(params[:id])
    @audio_playlist.locked = false
    @audio_playlist.save

    respond_to do |format|
      flash[:notice] = 'Playlist was unlocked'
      format.html { redirect_to(audio_playlists_path) }
    end
  end

  def duplicate

    @playlist = AudioPlaylist.find(params[:id])
    @playlist_duplicate = AudioPlaylist.create(

    :client_playlist_code => @playlist.client_playlist_code,
    :airline_id => @playlist.airline_id,
    :in_out => @playlist.in_out,
    :start_playdate => @playlist.start_playdate,
    :end_playdate => @playlist.end_playdate,
    :vo => @playlist.vo,
    :program_id => @playlist.program_id,
    :user_id => current_user.id ,
    :airline_cache => @playlist.airline_cache,
    :program_cache => @playlist.program_cache      

    )

    @playlist.audio_playlist_tracks.each do |item|

      AudioPlaylistTrack.create(
      :track_id => item.track_id,
      :position => item.position,
      :audio_playlist_id => @playlist_duplicate.id
      )

    end

    respond_to do |format|
      format.html { redirect_to(audio_playlists_path) }
    end
  end

  def find_track

    conditions = ""
    if !params['min_dur_min'].empty? || !params['min_dur_sec'].empty?
      tot_dur = dur_to_ms params['min_dur_min'], params['min_dur_sec']
      conditions = "duration > #{tot_dur}" 
    end
    if !params['max_dur_min'].empty? || !params['max_dur_sec'].empty?
      if conditions != ""
        conditions += " AND "
      end
      tot_dur = dur_to_ms params['max_dur_min'], params['max_dur_sec']
      conditions += "duration < #{tot_dur}" 

    end

    if params['title'].strip.length > 0

      @tracks = Track.search(params['title'], ['tracks.title_original', 'tracks.title_english', 'tracks.artist_original', 'tracks.artist_english', 'labels.name'], {:conditions => conditions, :from => '(tracks left join albums on albums.id=tracks.album_id) left join labels on albums.label_id=labels.id', :select=>'tracks.*'})

    end  

  end

  #display overlay
  def add_track_to_playlist

    dur_min = (params[:dur_min_min].to_i * 60  *1000) + (params[:dur_min_sec].to_i * 1000)
    dur_max = (params[:dur_max_min].to_i * 60  *1000) + (params[:dur_max_sec].to_i * 1000)

    if !params[:audio_playlists].nil?

      @search = Track.new_search(params[:audio_playlists])
      @search.conditions.to_delete_equals=0
      @search.conditions.duration_greater_than = dur_min
      if !dur_max.zero?
        @search.conditions.duration_less_than = dur_max
      end

      if !params[:search].nil?
        search = params[:search]
        @search.per_page = search[:per_page] if !search[:per_page].nil? 
        @search.page = search[:page] if !search[:page].nil?
      end
      @tracks, @tracks_count = @search.all, @search.count

    else
      @search = Track.new_search
      @tracks = nil
      @tracks_count = 0
    end         

    respond_to do |format|
      format.html 
      format.js {
        if params[:audio_playlists].nil? && params[:search].nil?
          render :action => 'add_track_to_playlist.rhtml', :layout => false
        else
          render :update do |page| 
            page.replace_html "tracks", :partial => "tracks"
          end
        end      
      }
    end
  end


  def add_track

    @audio_playlist = AudioPlaylist.find(params[:id])  
    @audio_playlist.updated_at_will_change!
    @audio_playlist.save  
    @audio_playlist_track = AudioPlaylistTrack.new(:audio_playlist_id => params[:id], :track_id => params[:track_id], :position => @audio_playlist.tracks.count + 1)

    #check if track has been added to a previous playlist before   
    @playlists_with_track = AudioPlaylistTrack.find(:all, 
    :conditions=>"track_id=#{params[:track_id]}",
    :group=>"audio_playlist_id")

    @notice=""

    @track = Track.find(params[:track_id])

    if !@playlists_with_track.empty? && params[:add].nil?
      @playlists_with_track.each do |playlist_track|
        @notice += "<br/><div id='exists'>Note! This track exists in playlist <a href='/audio_playlists/#{playlist_track.audio_playlist_id.to_s}' target='_blank'>#{playlist_track.audio_playlist_id.to_s}</a> (#{playlist_track.audio_playlist.client_playlist_code.to_s})</div>"
      end      
    else				      
      if @audio_playlist_track.save
        flash[:notice] = 'Track was successfully added.'					
      end
    end

    respond_to do |format|
      format.html { }
      format.js
    end
  end

  def export
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="excel-export.xls"'
    headers['Cache-Control'] = ''
    @audio_playlist = AudioPlaylist.find(params[:id])
  end

  def export_to_excel
    @audio_playlist = AudioPlaylist.find(params[:id])

    #create excel file

    book = Spreadsheet::Workbook.new
    sheet = SheetWrapper.new(book.create_worksheet)
    sheet.add_row [ "Airline Code", "Airline Name", "Playdate Start Month", "Playdate Start Year", 
                    "Playdate End Month", "Playdate End Year", "VO", "Total Duration", "Airline Duration"]

    # header row

    if @audio_playlist.airline_id.nil?
      airline_code = ''
      airline_name = ''
    else
      airline_code = @audio_playlist.airline.code
      airline_name = @audio_playlist.airline.name
    end
    vo = @audio_playlist.vo.name if !@audio_playlist.vo_id.nil?
    sheet.add_row [airline_code, airline_name, @audio_playlist.start_playdate.strftime("%B"),  
        @audio_playlist.start_playdate.strftime("%Y"), @audio_playlist.end_playdate.strftime("%B"),  
        @audio_playlist.end_playdate.strftime("%Y"), vo, @audio_playlist.total_duration_cached, @audio_playlist.airline_duration ]

    sheet.add_lines(1)

    # header row
    sheet.add_row ["Mastering", "Song Order", "Title (Translated)", "Title (Original)", 
        "Artist (Translated)", "Artist (Original)", "Label", "Origin", "Composer", "Duration", 
        "Split (min)", "VO Duration (sec)", "Accumulated Duration"]

    accum_duration = 0
    # data rows
    @audio_playlist.audio_playlist_tracks_sorted.each do |audio_playlist_track|
      if !audio_playlist_track.track.album.label_id.nil?
        label = audio_playlist_track.track.album.label.name 
      else
        label =""
      end

      if !audio_playlist_track.track.origin_id.nil? && audio_playlist_track.track.origin_id!=0
        origin = audio_playlist_track.track.origin.name 
      else
        origin =""
      end  

      if audio_playlist_track.vo_duration.nil? 
        vo_duration=0
      else
        vo_duration = audio_playlist_track.vo_duration.to_i
      end

      split = ""
      split =  "#{audio_playlist_track.split} min" if !audio_playlist_track.split.nil? && audio_playlist_track.split!=0 && audio_playlist_track.split!=""

      sheet.add_row [audio_playlist_track.mastering, 
        audio_playlist_track.position, 
        audio_playlist_track.track.title_english, 
        audio_playlist_track.track.title_original, 
        audio_playlist_track.track.artist_english, 
        audio_playlist_track.track.artist_original, 
        label, 
        origin, 
        audio_playlist_track.track.composer, 
        audio_playlist_track.track.duration_in_min, 
        split, 
        audio_playlist_track.vo_duration, 
        duration(accum_duration + audio_playlist_track.track.duration)]

        if !audio_playlist_track.split.nil? && audio_playlist_track.split!=0
          accum_duration = 0
        else
          accum_duration += audio_playlist_track.track.duration + (vo_duration*1000)
        end

      end

      # send it to the browsah
      data = StringIO.new ''
      book.write data
      send_data data.string, :type=>"application/excel", 
      :disposition=>'attachment', :filename => 'audio_playlist.xls'
    end


    def set_audio_playlist_track_split
      audio_playlist_track = AudioPlaylistTrack.find(params[:id])
      audio_playlist_track.split = params[:audio_playlist_track][:split]
      audio_playlist_track.save
      @audio_playlist = AudioPlaylist.find(audio_playlist_track.audio_playlist_id)
    end

    def set_audio_playlist_track_vo_duration
      audio_playlist_track = AudioPlaylistTrack.find(params[:id])
      audio_playlist_track.vo_duration = params[:audio_playlist_track][:vo_duration]		
      audio_playlist_track.save
      @audio_playlist = AudioPlaylist.find(audio_playlist_track.audio_playlist_id)
      @audio_playlist.updated_at_will_change!
      @audio_playlist.save
    end

  def splits
    @splits = Split.find(:all, :order=>:duration, :order=>:duration)
    render  :layout => false
  end
    
  def mp3

    playlist = AudioPlaylist.find(params[:id])
    
    tracks = playlist.tracks.map{|t| t.id }.flatten.uniq
    albums = playlist.tracks.map{|t| t.album.id }.flatten.uniq
    
    require 'xmlrpc/client' 
    server = XMLRPC::Client.new2('http://iim/rpcserver.php')         
    @zipfile_path = server.call('mp3', tracks, albums)
  end
  
  def download_mp3
    
    @playlist_id = params[:id]
    playlist = AudioPlaylist.find(@playlist_id)
    
    tracks_found = playlist.audio_playlist_tracks_sorted.delete_if{|playlist_track| playlist_track.track.mp3_exists==false}
    
    #track_names = tracks_found.map{|t| t.position.to_s + "-" + t.track.title_original }.flatten
    track_names = tracks_found.map{|t| t.position.to_s }.flatten
    albums = tracks_found.map{|t| t.track.album_id }.flatten
    tracks = tracks_found.map{|t| t.track.track_num }.flatten
    
    
    require 'xmlrpc/client' 
    client = XMLRPC::Client.new2(Settings.nas_url)      
    begin   
      result = client.call('create_songs_zip', Settings.iim_app_id, @playlist_id, albums, tracks, track_names)
    rescue Timeout::Error => e
      flash[:notice] = 'Could not connect to NAS'
    end
    
    if result
      respond_to do |format|
        format.js {
          render :action => 'download_mp3.rhtml', :layout => false
        }
      end
    end
      
  end
  
end