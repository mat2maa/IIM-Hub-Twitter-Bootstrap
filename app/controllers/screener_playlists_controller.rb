require "spreadsheet"
require 'stringio'

class ScreenerPlaylistsController < ApplicationController
  in_place_edit_for :screener_playlist_item, :mastering
  
  layout "layouts/application" ,  :except => :export
  before_filter :require_user
  filter_access_to :all
  
  
  def index
    if !params['search'].nil?
      @search = ScreenerPlaylist.new_search(params[:search])
    else 
      @search = ScreenerPlaylist.new_search(:order_by => :id, :order_as => "DESC")
    end
    
    @screener_playlists, @screener_playlists_count = @search.all, @search.count
  end
  
  def new
    @screener_playlist = ScreenerPlaylist.new	
  end
  
  def create

    @screener_playlist = ScreenerPlaylist.new(params[:screener_playlist])
    @screener_playlist.user_id = current_user.id
    @screener_playlist.locked = false;

    respond_to do |format|
      if @screener_playlist.save
        flash[:notice] = 'Playlist was successfully created.'

        format.html { redirect_to(edit_screener_playlist_path(@screener_playlist)) }

      else
        format.html { render :action => "new" }

      end
    end
  end
  
  def edit 
    @screener_playlist = ScreenerPlaylist.find(params[:id],:include=>[:screener_playlist_items,:screeners])
    session[:screeners_search] = collection_to_id_array(@screener_playlist.screeners)
    
  end 

  def update
    @screener_playlist = ScreenerPlaylist.find(params[:id])

    respond_to do |format|
      if @screener_playlist.update_attributes(params[:screener_playlist])
        flash[:notice] = 'Playlist was successfully updated.'
        format.html { redirect_to(:back) }

      else
        format.html { render :action => "edit" }

      end
    end
  end
  
  def show 
    @screener_playlist = ScreenerPlaylist.find(params[:id],:include=>[:screener_playlist_items,:screeners])
  end
  
  #display overlay
  def add_screener_to_playlist
    if !params[:screener_playlists].nil?
      @search = Screener.new_search(params[:screener_playlists])      
      if !params[:search].nil?
        search = params[:search]        
        @search.per_page = search[:per_page] if !search[:per_page].nil? 
        @search.page = search[:page] if !search[:page].nil?
      end
      
      @screeners, @screeners_count = @search.all, @search.count

    else
      @screeners = nil
      @screeners_count = 0
      @search = Screener.new_search
    end

    respond_to do |format|
      format.html 

      format.js {
        if params[:screener_playlists].nil? && params[:search].nil?
          render :action => 'add_screener_to_playlist.rhtml', :layout => false 
        else
          render :update do |page| 
            page.replace_html "screeners", :partial => "screeners"
          end
        end      
      }
    end
  end
  
  #add screener to playlist
  def add_screener

    @screener_playlist = ScreenerPlaylist.find(params[:id])
    @screener_playlist_item = ScreenerPlaylistItem.new(:screener_playlist_id => params[:id], :screener_id => params[:screener_id], :position => @screener_playlist.screener_playlist_items.count + 1)

    #check if video has been added to a previous playlist before    
    @playlists_with_video = ScreenerPlaylistItem.find(:all, 
    :conditions=>"screener_id=#{params[:screener_id]}",
    :group=>"screener_playlist_id")
    @notice=""

    @screener_to_add = Screener.find(params[:screener_id])

    if !@playlists_with_video.empty? && params[:add].nil?
      @playlists_with_video.each do |playlist_item|
        @notice += "<br/><div id='exists'>Note! This video #{@screener_to_add.id.to_s} exists in playlist <a href='/screener_playlists/#{playlist_item.screener_playlist_id.to_s}' target='_blank'>#{playlist_item.screener_playlist_id.to_s}</a></div>" if !playlist_item.screener_playlist.nil?
      end     

    else
      if @screener_playlist_item.save
        flash[:notice] = 'Screener was successfully added.'
        session[:screeners_search] = collection_to_id_array(@screener_playlist.screeners)
      end
    end
  end  
  
  #add selected videos to playlist
  def add_multiple_screeners
    
    @notice = ""
    @screener_playlist = ScreenerPlaylist.find(params[:playlist_id])
    screener_ids = params[:screener_ids]
    
    screener_ids.each do |screener_id|
      @screener_playlist_item = ScreenerPlaylistItem.new(:screener_playlist_id => params[:playlist_id], :screener_id => screener_id, :position => @screener_playlist.screener_playlist_items.count + 1)
    
      #check if video has been added to a previous playlist before    
      @playlists_with_video = ScreenerPlaylistItem.find(:all, 
      :conditions=>"screener_id=#{screener_id}",
      :group=>"screener_playlist_id")

      @screener_to_add = Screener.find(screener_id)
      if !@playlists_with_video.empty? && params[:add].nil?
        @playlists_with_video.each do |playlist_item|
          if !playlist_item.screener_playlist.nil?
            if !playlist_item.screener_playlist.airline_id.nil?
              airline_code = Airline.find(playlist_item.screener_playlist.airline_id).code
            else
              airline_code = ""
            end
            @notice += "<br/><div id='exists'>Note! This video #{@screener_to_add.episode_title.to_s} exists in playlist 
                        <a href='/screener_playlists/#{playlist_item.screener_playlist_id.to_s}' target='_blank'>#{airline_code}#{playlist_item.screener_playlist.start_cycle.strftime("%m%y")}</a></div>
                        #{@template.link_to_remote("Continue adding " + @screener_to_add.episode_title.to_s + " to playlist", 
                        :url => {:controller => "screener_playlists", 
                        :action => "add_screener", 
                        :id => params[:playlist_id], 
                        :screener_id => screener_id,
                        :add => 1},
                        :loading => "Element.show('spinner')",
                        :complete => "Element.hide('spinner')")}" 
          end
        end     
      else
        if @screener_playlist_item.save
          flash[:notice] = 'Screeners were successfully added.'
          session[:screeners_search] = collection_to_id_array(@screener_playlist.screeners)
        end
      end
    end # loop through video ids
    
  end
  
  def destroy
    @screener_playlist = ScreenerPlaylist.find(params[:id])
    @screener_playlist.destroy

    respond_to do |format|
      format.html { redirect_to(screener_playlists_path) }
      format.js
    end
  end

  def lock
    @screener_playlist = ScreenerPlaylist.find(params[:id])
    @screener_playlist.locked = true
    @screener_playlist.save

    respond_to do |format|
      flash[:notice] = 'Playlist was locked'
      format.html { redirect_to(screener_playlists_path) }
    end
  end

  def unlock
    @screener_playlist = ScreenerPlaylist.find(params[:id])
    @screener_playlist.locked = false
    @screener_playlist.save

    respond_to do |format|
      flash[:notice] = 'Playlist was unlocked'
      format.html { redirect_to(screener_playlists_path) }
    end
  end
  
  def print

    @screener_playlist = ScreenerPlaylist.find(params[:id]) 	
    headers["Content-Disposition"] =  "attachment; filename=\"#{@screener_playlist.airline.code if !@screener_playlist.airline.nil? }#{@screener_playlist.start_cycle.strftime("%m%y")}.pdf\""        

    respond_to do |format|
      format.html
      format.pdf {
        render :text => PDFKit.new(print_video_playlist_url(@screener_playlist)).to_pdf, :layout => false 
      }
    end
    
  end
  
  
  def export_to_excel
    @screener_playlist = ScreenerPlaylist.find(params[:id])

    #create excel file

    book = Spreadsheet::Workbook.new
    sheet = SheetWrapper.new(book.create_worksheet)
    sheet.add_row ["Airline Name", "Start Cycle", "End Cycle"]

    if @screener_playlist.airline_id.nil?
      airline_code = ''
      airline_name = ''
    else
      airline_code = @screener_playlist.airline.code
      airline_name = @screener_playlist.airline.name
    end

    sheet.add_row [airline_code, airline_name, @screener_playlist.start_cycle.strftime("%B"),  @screener_playlist.start_cycle.strftime("%Y"), @screener_playlist.end_cycle.strftime("%B"),  @screener_playlist.end_cycle.strftime("%Y")]

    sheet.add_lines(1)
    
    screener_playlist_items = @screener_playlist.screener_playlist_items_sorted
    
    # Screener Playlist Summary
    # header row
    sheet.add_row ["Position", "Episode Title", "Episode Number", "Remarks", "Other", "Location"]

    # data rows
    screener_playlist_items.each do |screener_playlist_item|

      sheet.add_row [screener_playlist_item.position, 
        screener_playlist_item.screener.episode_title, 
        screener_playlist_item.screener.episode_number, 
        screener_playlist_item.screener.remarks, 
        screener_playlist_item.screener.remarks_other, 
        screener_playlist_item.screener.location]
      end

      sheet.add_lines(1)

      data = StringIO.new ''
      book.write data
      send_data data.string, :type=>"application/excel", 
      :disposition=>'attachment', :filename => "#{airline_code}#{@screener_playlist.start_cycle.strftime("%m%y")} Video Screener Playlist.xls"
  end

  def sort
    params[:screenerplaylist].each_with_index do |id, pos|
      ScreenerPlaylistItem.find(id).update_attribute(:position, pos+1)
    end
    render :nothing => true
  end


  def duplicate

    @playlist = ScreenerPlaylist.find(params[:id])
    @playlist_duplicate = ScreenerPlaylist.create(
      :start_cycle => @playlist.start_cycle,
      :end_cycle => @playlist.end_cycle,
      :user_id => current_user.id
    )

    @playlist.screener_playlist_items.each do |item|

      ScreenerPlaylistItem.create(
      :screener_id => item.screener_id,
      :position => item.position,
      :mastering => item.mastering,
      :screener_playlist_id => @playlist_duplicate.id
      )

    end

    respond_to do |format|
      format.html { redirect_to(edit_screener_playlist_path(@playlist_duplicate)) }
    end
  end

end
