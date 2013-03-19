require "spreadsheet"
require 'stringio'

class VideoMasterPlaylistsController < ApplicationController
  in_place_edit_for :video_master_playlist_item,
                    :mastering

  layout "layouts/application",
         except: :export
  before_filter :require_user
  filter_access_to :all


  def index
    if !params[:q].nil?
      @search = VideoMasterPlaylist.ransack(params[:q])
      @video_master_playlists = @search.result(distinct: true)
      .paginate(page: params[:page],
                per_page: 10)
    else
      @search = VideoMasterPlaylist.ransack(params[:q])
      @video_master_playlists = @search.result(distinct: true)
      .order("id DESC")
      .paginate(page: params[:page],
                per_page: 10)
    end

    @video_master_playlists_count = @video_master_playlists.count
  end

  def new
    @video_master_playlist = VideoMasterPlaylist.new
  end

  def create

    @video_master_playlist = VideoMasterPlaylist.new(params[:video_master_playlist])
    @video_master_playlist.user_id = current_user.id
    @video_master_playlist.locked = false;

    respond_to do |format|
      if @video_master_playlist.save
        flash[:notice] = 'Playlist was successfully created.'

        format.html { redirect_to(edit_video_master_playlist_path(@video_master_playlist)) }

      else
        format.html { render action: "new" }

      end
    end
  end

  def edit
    @video_master_playlist = VideoMasterPlaylist.find(params[:id], include: [:video_master_playlist_items, :masters])
    session[:masters_search] = collection_to_id_array(@video_master_playlist.masters)

  end

  def update
    @video_master_playlist = VideoMasterPlaylist.find(params[:id])

    respond_to do |format|
      if @video_master_playlist.update_attributes(params[:video_master_playlist])
        flash[:notice] = 'Playlist was successfully updated.'
        format.html { redirect_to(:back) }

      else
        format.html { render action: "edit" }

      end
    end
  end

  def show
    @video_master_playlist = VideoMasterPlaylist.find(params[:id], include: [:video_master_playlist_items, :masters])
  end

  #display overlay
  def add_master_to_playlist
    @languages = MasterLanguage.order("name")
    .collect { |language| language.name }
    @video_master_playlist = VideoMasterPlaylist.find(params[:id])
    if !params[:video_master_playlists].nil?
      @search = Master.new_search(params[:video_master_playlists])
      @search.conditions.video.programme_title_keywords = params[:video_master_playlists][:conditions][:video][:programme_title_keywords].gsub(/\'s|\'t/,
                                                                                                                                               "")
      @search.conditions.episode_title_keywords = params[:video_master_playlists][:conditions][:episode_title_keywords].gsub(/\'s|\'t/,
                                                                                                                             "")
      @search.conditions.active = true
      if !params[:search].nil?
        search = params[:search]
        @search.per_page = search[:per_page] if !search[:per_page].nil?
        @search.page = search[:page] if !search[:page].nil?
      end

      @masters,
          @masters_count = @search.all,
          @search.count

    else
      @masters = nil
      @masters_count = 0
      @search = Master.ransack(params[:q])
    end

    respond_to do |format|
      format.html

      format.js {
        if params[:video_master_playlists].nil? && params[:search].nil?
          render action: 'add_video_master_to_playlist.rhtml',
                 layout: false
        else
          render :update do |page|
            page.replace_html "masters",
                              partial: "masters"
          end
        end
      }
    end
  end

  #add master to playlist
  def add_master

    @video_master_playlist = VideoMasterPlaylist.find(params[:id])
    @video_master_playlist_item = VideoMasterPlaylistItem.new(video_master_playlist_id: params[:id],
                                                              master_id: params[:master_id],
                                                              position: @video_master_playlist.video_master_playlist_items.count + 1)

    @notice=""

    @master_to_add = Master.find(params[:master_id])

    if @video_master_playlist_item.save
      flash[:notice] = 'Master was successfully added.'
      session[:masters_search] = collection_to_id_array(@video_master_playlist.masters)
    end
  end

  #add selected videos to playlist
  def add_multiple_masters

    @notice = ""
    @video_master_playlist = VideoMasterPlaylist.find(params[:playlist_id])
    master_ids = params[:master_ids]

    master_ids.each do |master_id|
      @video_master_playlist_item = VideoMasterPlaylistItem.new(video_master_playlist_id: params[:playlist_id],
                                                                master_id: master_id,
                                                                position: @video_master_playlist.video_master_playlist_items.count + 1)

      @master_to_add = Master.find(master_id)
      if @video_master_playlist_item.save
        flash[:notice] = 'Masters were successfully added.'
        session[:masters_search] = collection_to_id_array(@video_master_playlist.masters)
      end
    end # loop through video ids

  end

  def destroy
    @video_master_playlist = VideoMasterPlaylist.find(params[:id])
    @video_master_playlist.destroy

    respond_to do |format|
      format.html { redirect_to(video_master_playlists_path) }
      format.js
    end
  end

  def lock
    @video_master_playlist = VideoMasterPlaylist.find(params[:id])
    @video_master_playlist.locked = true
    @video_master_playlist.save

    respond_to do |format|
      flash[:notice] = 'Playlist was locked'
      format.html { redirect_to(video_master_playlists_path) }
    end
  end

  def unlock
    @video_master_playlist = VideoMasterPlaylist.find(params[:id])
    @video_master_playlist.locked = false
    @video_master_playlist.save

    respond_to do |format|
      flash[:notice] = 'Playlist was unlocked'
      format.html { redirect_to(video_master_playlists_path) }
    end
  end

  def print

    @video_master_playlist = VideoMasterPlaylist.find(params[:id])
    if @video_master_playlist.master_playlist_type.nil?
      video_type = " "
    else
      video_type = " " + @video_master_playlist.master_playlist_type.name
    end
    headers["Content-Disposition"] = "attachment; filename=\"#{@video_master_playlist.airline.code if !@video_master_playlist.airline.nil? }#{@video_master_playlist.start_cycle.strftime("%m%y")}#{video_type} Master.pdf\""

    respond_to do |format|
      format.html
      format.pdf {
        render text: PDFKit.new(print_video_playlist_url(@video_master_playlist)).to_pdf,
               layout: false
      }
    end

  end


  def export_to_excel
    @video_master_playlist = VideoMasterPlaylist.find(params[:id])

    #create excel file

    book = Spreadsheet::Workbook.new
    sheet = SheetWrapper.new(book.create_worksheet)
    sheet.add_row ["Airline Name",
                   "Start Cycle",
                   "End Cycle"]

    if @video_master_playlist.airline_id.nil?
      airline_code = ''
      airline_name = ''
    else
      airline_code = @video_master_playlist.airline.code
      airline_name = @video_master_playlist.airline.name
    end

    sheet.add_row [airline_code,
                   airline_name,
                   @video_master_playlist.start_cycle.strftime("%B"),
                   @video_master_playlist.start_cycle.strftime("%Y"),
                   @video_master_playlist.end_cycle.strftime("%B"),
                   @video_master_playlist.end_cycle.strftime("%Y")]
    sheet.add_lines(1)

    sheet.add_row ["Media Instruction"]
    sheet.add_row [@video_master_playlist.media_instruction]

    sheet.add_lines(1)

    video_master_playlist_items = @video_master_playlist.video_master_playlist_items_sorted

    # Master Playlist Summary
    # header row
    sheet.add_row ["Position",
                   "Programme Title",
                   "Episode Title",
                   "Episode Number",
                   "Distributor",
                   "Tape Media",
                   "Tape Format",
                   "Tape Size",
                   "Aspect Ratio",
                   "Language Track 1",
                   "Language Track 2",
                   "Language Track 3",
                   "Language Track 4",
                   "Video Subtitles 1",
                   "Video Subtitles 2",
                   "Master Tape Location",
                   "Master Time In",
                   "Master Time Out",
                   "Duration",
                   "Programme Synopsis",
                   "Episode Synopsis",
                   "Genre,
Sub-Genre",
                   "Mastering"]

    # data rows
    video_master_playlist_items.each do |video_master_playlist_item|

      if video_master_playlist_item.master.video.video_distributor.nil?
        distributor = ""
      else
        distributor = video_master_playlist_item.master.video.video_distributor.company_name
      end

      if !video_master_playlist_item.master.nil?
        sheet.add_row [video_master_playlist_item.position,

                       video_master_playlist_item.master.video.programme_title,

                       video_master_playlist_item.master.episode_title,

                       video_master_playlist_item.master.episode_number,

                       distributor,

                       video_master_playlist_item.master.tape_media,

                       video_master_playlist_item.master.tape_format,

                       video_master_playlist_item.master.tape_size,

                       video_master_playlist_item.master.aspect_ratio,

                       video_master_playlist_item.master.language_track_1,

                       video_master_playlist_item.master.language_track_2,

                       video_master_playlist_item.master.language_track_3,

                       video_master_playlist_item.master.language_track_4,

                       video_master_playlist_item.master.video_subtitles_1,

                       video_master_playlist_item.master.video_subtitles_2,

                       video_master_playlist_item.master.location,

                       video_master_playlist_item.master.time_in,

                       video_master_playlist_item.master.time_out,
                       video_master_playlist_item.master.duration,

                       video_master_playlist_item.master.video.synopsis,

                       video_master_playlist_item.master.synopsis,
                       video_master_playlist_item.master.video.video_genres_string_with_parent,
                       video_master_playlist_item.mastering,
                      ]
      end
    end

    sheet.add_lines(1)

    if @video_master_playlist.master_playlist_type.nil?
      video_type = " "
    else
      video_type = " " + @video_master_playlist.master_playlist_type.name
    end

    data = StringIO.new ''
    book.write data
    send_data data.string,
              type: "application/excel",
              disposition: 'attachment',
              filename: "#{airline_code}#{@video_master_playlist.start_cycle.strftime("%m%y")}#{video_type} Master.xls"
  end

  def sort
    params[:videoplaylist].each_with_index do |id,
        pos|
      VideoMasterPlaylistItem.find(id).update_attribute(:position,
                                                        pos+1)
    end
    render nothing: true
  end


  def duplicate

    @playlist = VideoMasterPlaylist.find(params[:id])
    @playlist_duplicate = VideoMasterPlaylist.create(
        start_cycle: @playlist.start_cycle,
        end_cycle: @playlist.end_cycle,
        user_id: current_user.id,
        media_instruction: @playlist.media_instruction
    )

    @video_master_playlist_items = VideoMasterPlaylistItem.where("video_master_playlist_id=#{@playlist.id}")
    .order("position ASC")

    @video_master_playlist_items.each do |item|

      VideoMasterPlaylistItem.create(
          master_id: item.master_id,
          position: item.position,
          mastering: item.mastering,
          video_master_playlist_id: @playlist_duplicate.id
      )

    end

    respond_to do |format|
      format.html { redirect_to(edit_video_master_playlist_path(@playlist_duplicate)) }
    end
  end

end
