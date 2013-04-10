require "spreadsheet"
require 'stringio'

class MoviePlaylistsController < ApplicationController
  layout "layouts/application",
         except: :export
  before_filter :require_user
  filter_access_to :all

  def index
    @search = MoviePlaylist.ransack(params[:q])
    if !params[:q].nil?
      @movie_playlists = @search.result(distinct: true)
                                .paginate(page: params[:page],
                                          per_page: 10)
    else
      @movie_playlists = @search.result(distinct: true)
                                .order("id DESC")
                                .paginate(page: params[:page],
                                          per_page: 10)
    end

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
    @movie_playlist = MoviePlaylist.find(params[:id], include: [:movie_playlist_items, :movies])
  end

  #display overlay
  def add_movie_to_playlist

    @movie_playlist = MoviePlaylist.find(params[:id])
    @languages = MasterLanguage.order("name")
                               .collect { |language| language.name }

    @search = Movie.ransack(params[:q])
    @movies = @search.result(distinct: true)
                     .where("to_delete = ?", "0")
                     .order("id DESC")
                     .paginate(page: params[:page],
                               per_page: 10)

    if params[:language].present?
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
    @movie_playlist_item = MoviePlaylistItem.new(movie_playlist_id: params[:id],
                                                 movie_id: params[:movie_id],
                                                 position: @movie_playlist.movie_playlist_items.count)
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
      @movie_playlist_item = MoviePlaylistItem.new(movie_playlist_id: params[:playlist_id],
                                                   movie_id: movie_id,
                                                   position: @movie_playlist.movie_playlist_items.count)

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

    @movie_playlist = MoviePlaylist.find(params[:id])
    headers["Content-Disposition"] = "attachment; filename=\"#{@movie_playlist.airline.code if !@movie_playlist
    .airline.code.nil?}#{@movie_playlist.start_cycle.strftime("%m%y")} #{@movie_playlist.movie_type if
        !@movie_playlist.movie_type.nil?}.pdf\""

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

                   "Poster",
                   "Critics Review"]

    # data rows
    movie_playlist_items.each do |movie_playlist_item|

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

      sheet.add_row [movie_playlist_item.position,

                     movie_playlist_item.movie.movie_title,

                     movie_playlist_item.movie.foreign_language_title,

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

                     "http://hub.iim.com.sg" + movie_playlist_item.movie.poster.url,

                     movie_playlist_item.movie.critics_review]
    end

    sheet.add_lines(1)

    data = StringIO.new ''
    book.write data
    send_data data.string,
              type: "application/excel",
              disposition: 'attachment',
              filename: "#{airline_code}#{@movie_playlist.start_cycle.strftime("%m%y")} #{@movie_playlist.movie_type}.xls"
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
        movie_type: @playlist.movie_type,
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
