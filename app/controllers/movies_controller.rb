class MoviesController < ApplicationController
  before_filter :require_user
  filter_access_to :all

  def index
    @languages = IIM::MOVIE_LANGUAGES

    if !params[:q].nil?
      if !params[:language].nil?
        if params[:language][:track]!="" && params[:language][:subtitle]==""
          @search = Movie.with_language_track(params[:language][:track]).ransack(params[:q])
        elsif params[:language][:subtitle]!="" && params[:language][:track]=="" && !params[:language].nil?
          @search = Movie.with_language_subtitle(params[:language][:subtitle]).ransack(params[:q])
        elsif params[:language][:subtitle]!="" && params[:language][:track]!="" && !params[:language].nil?
          @search = Movie.with_language_subtitle(params[:language][:subtitle]).with_language_track(params[:language][:track]).ransack(params[:q])
        else
          @search = Movie.ransack(params[:q])
          @search.conditions.active_equals = true

          @search.conditions.or_movie_title_keywords = params[:search][:conditions][:or_movie_title_keywords].gsub(/\'s|\'t/,
                                                                                                                   "")
          @search.conditions.or_foreign_language_title_keywords = params[:search][:conditions][:or_movie_title_keywords].gsub(/\'s|\'t/,
                                                                                                                              "")
        end

        if params[:screener][:destroyed] == "1"
          @search.conditions.screener_destroyed_date_not_equal = nil
          @search.conditions.and_screener_destroyed_date_not_equal = ""
        end
        if params[:screener][:held] == "1"
          @search.conditions.screener_received_date_not_equal = nil
          @search.conditions.and_screener_received_date_not_equal = ""
        end

      else
        @search = Movie.ransack(params[:q])
        @search.conditions.active_equals = true

      end
    else
      #no search made yet
      @search = Movie.ransack(params[:q])
      #TODO What is active_equals?
      #@search.conditions.active_equals = true
    end

    #@search.conditions.active_equals = true
    @movies = @search.result(distinct: true)
    .order("id DESC")
    .paginate(page: params[:page],
              per_page: 10)
    @movies_count = @movies.count

    if @movies_count == 1
      redirect_to(edit_movie_path(@movies.first))
    end

    session[:movies_search] = collection_to_id_array(@movies)
  end


  def show
    @movie = Movie.find(params[:id])
    if !session[:movies_search].nil?
      ids = session[:movies_search]
      id = ids.index(params[:id].to_i)
      if !id.nil?
        @next_id = ids[id+1] if (id+1 < ids.count)
        @prev_id = ids[id-1] if (id-1 >= 0)
      end
    end
  end

  def new
    @movie = Movie.new
    @movie.theatrical_release_year = Date.today.year
    @movie.release_versions = ["Th"]
    @movie.movie_type = "Hollywood Movie"
    @movie.airline_rights = "Worldwide"
    @movie.language_tracks = ["En"]
    @movie.screener_received_date = nil
    @movie.screener_destroyed_date = nil
    @movie.airline_release_date = nil
    @movie.personal_video_date = nil

    @languages = IIM::MOVIE_LANGUAGES
  end

  def create

    @movie = Movie.new(params[:movie])
    @movie.movie_title = @movie.movie_title.upcase
    @movie.foreign_language_title = @movie.foreign_language_title.upcase if !@movie.foreign_language_title.nil?
    @movie.director = @movie.director.gsub(/\b\w/) { $&.upcase }
    @movie.cast = @movie.cast.gsub(/\b\w/) { $&.upcase }

#    respond_to do |format|
    if @movie.save
      flash[:notice] = 'Movie was successfully created.'
      redirect_to edit_movie_path(@movie)
    else
      render action: 'new'
    end
    #   end
  end

  def edit
    @languages = IIM::MOVIE_LANGUAGES

    @search = Movie.ransack(params[:q])
    @movies = @search.result(distinct: true)
    .order("id DESC")
    .paginate(page: params[:page],
              per_page: 10)
    @movies_count = @movies.count

    @movie = Movie.find(params[:id])
    if !session[:movies_search].nil?
      ids = session[:movies_search]
      id = ids.index(params[:id].to_i)
      if !id.nil?
        @next_id = ids[id+1] if (id+1 < ids.count)
        @prev_id = ids[id-1] if (id-1 >= 0)
      end
    end
  end

  def update
    @search = Movie.ransack(params[:q])
    @movies = @search.result(distinct: true)
    .order("id DESC")
    .paginate(page: params[:page],
              per_page: 10)
    @movies_count = @movies.count

    @movie = Movie.find(params[:id])
    params[:movie][:movie_title] = params[:movie][:movie_title].upcase
    params[:movie][:director] = params[:movie][:director].gsub(/\b\w/) { $&.upcase }
    params[:movie][:cast] = params[:movie][:cast].gsub(/\b\w/) { $&.upcase }
    params[:movie][:foreign_language_title] = params[:movie][:foreign_language_title].upcase if !params[:movie][:foreign_language_title].nil?

    if @movie.update_attributes(params[:movie])
      flash[:notice] = "Successfully updated movie."
      redirect_to edit_movie_path(@movie)
    else
      render action: 'edit'
    end
  end

  def destroy
    @movie = Movie.find(params[:id])

    #check if video is in any playlists
    tot_playlists =MoviePlaylistItem.count(conditions: 'movie_id=' + @movie.id.to_s)

    if tot_playlists.zero?
      if permitted_to? :admin_delete,
                       :movies
        @movie.destroy
        flash[:notice] = "Successfully deleted movie."
        @movie_is_deleted = true
      else
        @movie.to_delete = true
        @movie.save(false)
        flash[:notice] = 'Movie will be deleted when approved by administrator'
        @movie_is_deleted = false
      end
    else
      @movie.active = false
      @movie.save
      flash[:notice] = "Successfully deleted movie."
      @movie_is_deleted = true

      #flash[:notice] = 'Movie could not be deleted, movie is in use for by playlists '
    end	
  	
    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.js
    end
  end
  
  def check_airline_rights
    respond_to do |format|
        format.js
    end
  end
  
  def check_screener_remarks
    respond_to do |format|
        format.js
    end
  end
  
  def check_movie_type
    respond_to do |format|
        format.js
    end
  end
  
  def update_date
    respond_to do |format|
        format.js
    end
  end
  
  def restore
    @movie = Movie.find(params[:id])
    @movie.to_delete = false
    @movie.save(false)
    flash[:notice] = '
                        Movie has been restored '
    respond_to do |format|
        format.html { redirect_to(:back) }
        format.js
    end
  end

end