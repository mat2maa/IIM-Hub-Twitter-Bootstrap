class MovieGenresController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @movie_genres = MovieGenre.find(:all, :order=>"name asc")	
	  respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @movie_genre = MovieGenre.find(params[:id])
  end

  def new
    @movie_genre = MovieGenre.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @movie_genre = MovieGenre.new params[:movie_genre]
      if @movie_genre.save
        flash[:notice] = 'MovieGenre was successfully created.'        
        format.html  { redirect_to(movie_genres_path) }
		    format.js
      else
      end
    end
  end
  
  def update
    @movie_genre = MovieGenre.find(params[:id])

    respond_to do |format|
      if @movie_genre.update_attributes(params[:movie_genre])
        #Movie.update_all(["movie_genre_cache=?",@movie_genre.name],["movie_genre_id=?",@movie_genre.id] )
        flash[:notice] = 'MovieGenre was successfully updated.'
        format.html { redirect_to(movie_genres_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	  id = params[:id]
		@movies = Movie.find(:all, :conditions => ["movie_genre_id = ?", id] )
		if @movies.length.zero?  
      @movie_genre = MovieGenre.find(id)
      @movie_genre.destroy
		else
			flash[:notice] = 'MovieGenre could not be deleted, movie_genre is in use in some tracks'
		end

    respond_to do |format|
      format.html { redirect_to(movie_genres_url) }
    end
  end
end
