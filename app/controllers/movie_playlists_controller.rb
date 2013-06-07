require "spreadsheet"
require 'stringio'

class MoviePlaylistsController < ApplicationController
  layout "layouts/application",
         except: :export
  before_filter :require_user
  filter_access_to :all

  def index
    @search = MoviePlaylist.includes(:airline)
                           .ransack(params[:q])
    @movie_playlists = @search.result(distinct: true)
                              .order("movie_playlists.id DESC")
                              .paginate(page: params[:page],
                                        per_page: items_per_page)

    @movie_playlists_count = @movie_playlists.count
  end

  def new
    @movie_playlist = MoviePlaylist.new
  end

  def create

    @movie_playlist = MoviePlaylist.new(params[:movie_playlist])
    @movie_playlist.user_id = current_user.id
    @movie_playlist.locked = false;

    respond_to do |format|
      if @movie_playlist.save
        flash[:notice] = 'Playlist was successfully created.'

        format.html { redirect_to(edit_movie_playlist_path(@movie_playlist)) }

      else
        format.html { render action: "new" }

      end
    end
  end

  def edit
    @movie_playlist = MoviePlaylist.find(params[:id], include: [:movie_playlist_items, :movies])
    session[:movies_search] = collection_to_id_array(@movie_playlist.movies)

    respond_to do |format|
      format.html {}
      format.pdf { render text: PDFKit.new(edit_movie_playlist_url(@movie_playlist),
                                           orientation: 'Landscape').to_pdf }

    end
  end

  def update
    @movie_playlist = MoviePlaylist.find(params[:id])

    respond_to do |format|
      if @movie_playlist.update_attributes(params[:movie_playlist])
        flash[:notice] = 'Playlist was successfully updated.'
        format.html { redirect_to(:back) }

      else
        format.html { render action: "edit" }

      end
    end
  end

  def show
    @movie_playlist = MoviePlaylist.includes(movie_playlist_items: :movie)
                                   .find(params[:id])
  end

  #display overlay
  def add_movie_to_playlist

    @movie_playlist = MoviePlaylist.find(params[:id])
    @languages = MasterLanguage.order("name")
                               .collect { |language| language.name }

    @search = Movie.ransack(params[:q])
    @movies = @search.result(distinct: true)
                     .where("to_delete = ?", "0")
                     .order("movies.id DESC")
                     .paginate(page: params[:page],
                               per_page: items_per_page)

    if params[:language].present?
      @movies = @movies.with_language_track(params[:language][:track]) if params[:language][:track].present?
      @movies = @movies.with_language_subtitle(params[:language][:subtitle]) if params[:language][:subtitle].present?

      @movies = @movies.with_screener_destroyed if params[:screener][:destroyed] == '1'
      @movies = @movies.with_screener_held if params[:screener][:held] == '1'
    end

    @movies_count = @movies.count

    respond_to do |format|
      format.js { render layout: false }
    end
  end

  #add movie to playlist
  def add_movie

    @movie_playlist = MoviePlaylist.find(params[:id])

    @movie_playlist_item_position = MoviePlaylistItem.where("movie_playlist_id=?", params[:id])
                                                     .order("position ASC")
                                                     .find(:last)
    @movie_playlist_item_position = @movie_playlist_item_position.nil? ? 1 : @movie_playlist_item_position.position + 1

    @movie_playlist_item = MoviePlaylistItem.new(movie_playlist_id: params[:id],
                                                 movie_id: params[:movie_id],
                                                 position: @movie_playlist_item_position)
    @notice=""
    @movie_to_add = Movie.find(params[:movie_id])
    if @movie_playlist_item.save
      flash[:notice] = 'Movie was successfully added.'
      session[:movies_search] = collection_to_id_array(@movie_playlist.movies)
    end
  end

  #add selected movies to playlist
  def add_multiple_movies

    @notice = ""
    @movie_playlist = MoviePlaylist.find(params[:playlist_id])
    movie_ids = params[:movie_ids]

    movie_ids.each do |movie_id|
      @movie_playlist_item_position = MoviePlaylistItem.where("movie_playlist_id=?", params[:playlist_id])
                                                       .order("position ASC")
                                                       .find(:last)
      @movie_playlist_item_position = @movie_playlist_item_position.nil? ? 1 : @movie_playlist_item_position.position + 1
      @movie_playlist_item = MoviePlaylistItem.new(movie_playlist_id: params[:playlist_id],
                                                   movie_id: movie_id,
                                                   position: @movie_playlist_item_position)

      if @movie_playlist_item.save
        flash[:notice] = 'Movies were successfully added.'
        @notice = 'Movies were successfully added.'
        session[:movies_search] = collection_to_id_array(@movie_playlist.movies)
      end
    end # loop through movie ids

  end

  def destroy
    @movie_playlist = MoviePlaylist.find(params[:id])
    @movie_playlist.destroy

    respond_to do |format|
      format.html { redirect_to(movie_playlists_path) }
      format.js
    end
  end

  def lock
    @movie_playlist = MoviePlaylist.find(params[:id])
    @movie_playlist.locked = true
    @movie_playlist.save

    respond_to do |format|
      flash[:notice] = 'Playlist was locked'
      format.html { redirect_to(movie_playlists_path) }
    end
  end

  def unlock
    @movie_playlist = MoviePlaylist.find(params[:id])
    @movie_playlist.locked = false
    @movie_playlist.save

    respond_to do |format|
      flash[:notice] = 'Playlist was unlocked'
      format.html { redirect_to(movie_playlists_path) }
    end
  end

  def print

    @movie_playlist = MoviePlaylist.includes(movie_playlist_items: :movie)
                                   .find(params[:id])
    language = params[:language]

    headers["Content-Disposition"] =  "attachment; filename=\"#{@movie_playlist.airline.code if !@movie_playlist.airline.nil? && !@movie_playlist.airline.code.nil?}#{@movie_playlist.start_cycle.strftime("%m%y")} #{@movie_playlist.movie_playlist_type.name if !@movie_playlist.movie_playlist_type.nil?}.pdf\""

    respond_to do |format|
      format.html
      format.pdf {
        render text: PDFKit.new(print_movie_playlist_url(@movie_playlist)).to_pdf,
               layout: false
      }
    end
  end


  def export_to_excel
    @movie_playlist = MoviePlaylist.find(params[:id])

    #create excel file

    book = Spreadsheet::Workbook.new
    sheet = SheetWrapper.new(book.create_worksheet)
    sheet.add_row ["Airline Name",
                   "Start Cycle",
                   "End Cycle"]

    if @movie_playlist.airline_id.nil?
      airline_code = ''
      airline_name = ''
    else
      airline_code = @movie_playlist.airline.code
      airline_name = @movie_playlist.airline.name
    end

    if @movie_playlist.start_cycle.nil?
      start_cycle_month = ''
      start_cycle_year = ''
    else
      start_cycle_month = @movie_playlist.start_cycle.strftime("%B")
      start_cycle_year = @movie_playlist.start_cycle.strftime("%Y")
    end

    if @movie_playlist.end_cycle.nil?
      end_cycle_month = ''
      end_cycle_year = ''
    else
      end_cycle_month = @movie_playlist.end_cycle.strftime("%B")
      end_cycle_year = @movie_playlist.end_cycle.strftime("%Y")
    end

    sheet.add_row [airline_code,
                   airline_name,
                   start_cycle_month,

                   start_cycle_year,
                   end_cycle_month,
                   end_cycle_year]

    sheet.add_lines(1)

    movie_playlist_items = @movie_playlist.movie_playlist_items_sorted

    # Movie Playlist Summary
    # header row
    sheet.add_row ["Position",
                   "Movie Title",
                   "Foreign Movie Title",
                   "Chinese Movie Title",
                   "Theatrical Release Year",
                   "Airline Release Date",
                   "Distributor",

                   "Production Company",
                   "Laboratory",
                   "Genre",
                   "Release Versions",
                   "Theatrical Run Time",
                   "Edited Run Time",

                   "Rating",
                   "Cast",
                   "Director",
                   "Synopsis",
                   "Chinese Cast",
                   "Chinese Director",
                   "Chinese Synopsis",
                   "IMDB Synopsis",

                   "Poster",
                   "Critics Review"]

    # data rows
    movie_playlist_items.each.with_index do |movie_playlist_item, index|

      if movie_playlist_item.movie.movie_distributor.nil?
        movie_distributor = ""
      else
        movie_distributor = movie_playlist_item.movie.movie_distributor.company_name
      end

      if movie_playlist_item.movie.production_studio.nil?
        production_studio = ""
      else
        production_studio = movie_playlist_item.movie.production_studio.company_name
      end

      if movie_playlist_item.movie.laboratory.nil?
        laboratory = ""
      else
        laboratory = movie_playlist_item.movie.laboratory.company_name
      end

      airline_release_date = ""
      airline_release_date = movie_playlist_item.movie.airline_release_date.strftime('%m-%Y') unless movie_playlist_item.movie.airline_release_date.nil?

      sheet.add_row [index + 1,

                     movie_playlist_item.movie.movie_title,

                     movie_playlist_item.movie.foreign_language_title,

                     movie_playlist_item.movie.chinese_movie_title,

                     movie_playlist_item.movie.theatrical_release_year,
                     airline_release_date,
                     movie_distributor,

                     production_studio,

                     laboratory,
                     movie_playlist_item.movie.movie_genres_string,

                     (movie_playlist_item.movie.release_versions.nil? ? "" : movie_playlist_item.movie.release_versions.join(',
')),
                     movie_playlist_item.movie.theatrical_runtime,

                     movie_playlist_item.movie.edited_runtime,

                     movie_playlist_item.movie.rating,

                     movie_playlist_item.movie.cast,
                     movie_playlist_item.movie.director,

                     movie_playlist_item.movie.synopsis,

                     movie_playlist_item.movie.chinese_cast,
                     movie_playlist_item.movie.chinese_director,

                     movie_playlist_item.movie.chinese_synopsis,

                     movie_playlist_item.movie.imdb_synopsis,

                     "http://hub.iim.com.sg" + movie_playlist_item.movie.poster.url,

                     movie_playlist_item.movie.critics_review]
    end

    sheet.add_lines(1)

    data = StringIO.new ''
    book.write data
    send_data data.string,
              type: "application/excel",
              disposition: 'attachment',
              filename: "#{airline_code}#{@movie_playlist.start_cycle.strftime("%m%y")} #{@movie_playlist.movie_playlist_type.name}.xls"
  end

  def download_thales_schema_package
    @movie_playlist = MoviePlaylist.find(params[:id])

    if @movie_playlist.airline_id.nil?
      airline_code = ''
      airline_name = ''
    else
      airline_code = @movie_playlist.airline.code
      airline_name = @movie_playlist.airline.name
    end

    if @movie_playlist.start_cycle.nil?
      start_cycle_day = ''
      start_cycle_month = ''
      start_cycle_year = ''
    else
      start_cycle_day = @movie_playlist.start_cycle.strftime("%d")
      start_cycle_month = @movie_playlist.start_cycle.strftime("%m")
      start_cycle_year = @movie_playlist.start_cycle.strftime("%Y")
    end

    if @movie_playlist.end_cycle.nil?
      end_cycle_day = ''
      end_cycle_month = ''
      end_cycle_year = ''
    else
      end_cycle_day = @movie_playlist.end_cycle.strftime("%d")
      end_cycle_month = @movie_playlist.end_cycle.strftime("%m")
      end_cycle_year = @movie_playlist.end_cycle.strftime("%Y")
    end

    t = Time.now
    t.to_s
    time = t.strftime "%H:%M:%S"

    xml = File.open(@movie_playlist.thales_schema_package.path)
    @movies = Nokogiri::XML(xml)
    xml.close
    ns = "http://services.extend.com/thales/m3"
    nodes = @movies.xpath("//x:*[@name='Movies']", "x" => ns)

    movie_playlist_items = @movie_playlist.movie_playlist_items_sorted

    nodes.each do |node|
      movie_playlist_items.each.with_index do |movie_playlist_item, index|
        content = Nokogiri::XML::Node.new "content", @movies
        content["name"] = movie_playlist_item.movie.movie_title.gsub(/\W+/, '').downcase.capitalize
        content["altId"] = rand(10 ** 20).to_s
        content["exhibitionStartDate"] = start_cycle_year + "-" + start_cycle_month + "-" + start_cycle_day + "T" + time
        content["exhibitionEndDate"] = end_cycle_year + "-" + end_cycle_month + "-" + end_cycle_day + "T" + time
        content["commonTitleId"] = movie_playlist_item.movie.movie_title.gsub(/\W+/, '').downcase.capitalize

        fld_title = Nokogiri::XML::Node.new "fld_title", @movies
        fld_shorttitle = Nokogiri::XML::Node.new "fld_shorttitle", @movies
        fld_genre_name = Nokogiri::XML::Node.new "fld_GenreName", @movies
        fld_actor = Nokogiri::XML::Node.new "fld_Actor", @movies
        fld_director = Nokogiri::XML::Node.new "fld_Director", @movies
        fld_rating = Nokogiri::XML::Node.new "fld_Rating", @movies
        fld_duration = Nokogiri::XML::Node.new "fld_Duration", @movies
        fld_audio_language = Nokogiri::XML::Node.new "fld_AudioLanguage", @movies
        fld_synopsis = Nokogiri::XML::Node.new "fld_Synopsis", @movies
        fld_standard_image = Nokogiri::XML::Node.new "fld_StandardImage", @movies
        fld_preview_video_asset = Nokogiri::XML::Node.new "fld_PreviewVideoAsset", @movies
        fld_preview_aspect_ratio = Nokogiri::XML::Node.new "fld_PreviewAspectRatio", @movies
        fld_cnt_pos = Nokogiri::XML::Node.new "fld_CntPos", @movies
        fld_subtitle_lang_text = Nokogiri::XML::Node.new "fld_subtitleLangText", @movies
        group = Nokogiri::XML::Node.new "group", @movies

        content.add_child(fld_title)
        fld_title_eng = Nokogiri::XML::Node.new "value", @movies
        fld_title_fra = Nokogiri::XML::Node.new "value", @movies
        fld_title_zho = Nokogiri::XML::Node.new "value", @movies
        fld_title_eng["lang"] = "eng"
        fld_title_fra["lang"] = "fra"
        fld_title_zho["lang"] = "zho"

        fld_title_eng.content = movie_playlist_item.movie.movie_title
        fld_title_fra.content = movie_playlist_item.movie.movie_title
        fld_title_zho.content = movie_playlist_item.movie.chinese_movie_title

        fld_title.add_child(fld_title_eng)
        fld_title.add_child(fld_title_fra)
        fld_title.add_child(fld_title_zho)


        content.add_child(fld_shorttitle)
        fld_shorttitle_eng = Nokogiri::XML::Node.new "value", @movies
        fld_shorttitle_fra = Nokogiri::XML::Node.new "value", @movies
        fld_shorttitle_zho = Nokogiri::XML::Node.new "value", @movies
        fld_shorttitle_eng["lang"] = "eng"
        fld_shorttitle_fra["lang"] = "fra"
        fld_shorttitle_zho["lang"] = "zho"

        fld_shorttitle_eng.content = movie_playlist_item.movie.movie_title
        fld_shorttitle_fra.content = movie_playlist_item.movie.movie_title
        fld_shorttitle_zho.content = movie_playlist_item.movie.chinese_movie_title

        fld_shorttitle.add_child(fld_shorttitle_eng)
        fld_shorttitle.add_child(fld_shorttitle_fra)
        fld_shorttitle.add_child(fld_shorttitle_zho)


        content.add_child(fld_genre_name)
        content.add_child(fld_actor)
        content.add_child(fld_director)
        content.add_child(fld_rating)
        content.add_child(fld_duration)
        content.add_child(fld_audio_language)
        content.add_child(fld_synopsis)
        content.add_child(fld_standard_image)
        content.add_child(fld_preview_video_asset)
        content.add_child(fld_preview_aspect_ratio)
        content.add_child(fld_cnt_pos)
        content.add_child(fld_subtitle_lang_text)
        content.add_child(group)

        node.add_child(content)

        #
        #content.children = fld_title
        #fld_title_eng = Nokogiri::XML::Node.new "value", @movies
        #fld_title_fra = Nokogiri::XML::Node.new "value", @movies
        #fld_title_zho = Nokogiri::XML::Node.new "value", @movies
        #fld_title_eng["lang"] = "eng"
        #fld_title_fra["lang"] = "fra"
        #fld_title_zho["lang"] = "zho"
        #
        #fld_title_eng.content = movie_1[0]
        #fld_title_fra.content = movie_1[0]
        #fld_title_zho.content = movie_1[1]
        #
        #fld_title.children = fld_title_eng
        #fld_title_eng.after(fld_title_fra)
        #fld_title_fra.after(fld_title_zho)
        #
        #fld_title.after(fld_shorttitle)
        #fld_shorttitle.after(fld_GenreName)
        #fld_GenreName.after(fld_Actor)
        #fld_Actor.after(fld_Director)
        #fld_Director.after(fld_Rating)
        #fld_Rating.after(fld_Duration)
        #fld_Duration.after(fld_AudioLanguage)
        #fld_AudioLanguage.after(fld_Synopsis)
        #fld_Synopsis.after(fld_StandardImage)
        #fld_StandardImage.after(fld_PreviewVideoAsset)
        #fld_PreviewVideoAsset.after(fld_PreviewAspectRatio)
        #fld_PreviewAspectRatio.after(fld_CntPos)
        #fld_CntPos.after(fld_subtitleLangText)
        #fld_subtitleLangText.after(group)
      end
    end

    data = @movies.to_xml
    send_data data,
              filename: "#{@movie_playlist.id}_thales_import_package.xml"
  end

=begin
  def sort
    params[:movieplaylist].each_with_index do |id,
        pos|
      MoviePlaylistItem.find(id).update_attribute(:position,
                                                  pos+1)
    end
    render nothing: true
  end
=end

  def duplicate

    @playlist = MoviePlaylist.find(params[:id])
    @playlist_duplicate = MoviePlaylist.create(
        start_cycle: @playlist.start_cycle,
        end_cycle: @playlist.end_cycle,
        movie_playlist_type_id: @playlist.movie_playlist_type_id,
        user_id: current_user.id
    )

    @movie_playlist_items = MoviePlaylistItem.where("movie_playlist_id=#{@playlist.id}").order("position ASC")

    @movie_playlist_items.each do |item|

      MoviePlaylistItem.create(
          movie_id: item.movie_id,
          position: item.position,
          movie_playlist_id: @playlist_duplicate.id
      )

    end

    respond_to do |format|
      format.html { redirect_to(edit_movie_playlist_path(@playlist_duplicate)) }
    end
  end

end