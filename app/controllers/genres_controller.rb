class GenresController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @genres = Genre.find(:all, :order=>"name asc")	
	respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @genre = Genre.find(params[:id])
  end

  def new
    @genre = Genre.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @genre }
    end
  end
  
  def create
	respond_to do |format|
      @genre = Genre.new params[:genre]
      if @genre.save
        flash[:notice] = 'Genre was successfully created.'        
        format.html  { redirect_to(genres_path) }
		format.js
      else
      end
    end
  end
  
  def update
    @genre = Genre.find(params[:id])

    respond_to do |format|
      if @genre.update_attributes(params[:genre])
        @albums = Albums.find(:all, :conditions=>"genre like '%#{@genre.name}%'" )
        @albums.each do |album|
          album.genre = get_genres(album.genres)
        end
        
        flash[:notice] = 'Genre was successfully updated.'
        format.html { redirect_to(genres_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def get_genres genres
    s = ""
	  i = 1
    genres.each do |g| 
	  if i == 1
	    s = g.name
	  else
        s = s + ", " + g.name 
      end
	  i += 1
    end

    s
  end
  
  def destroy


	@albums = AlbumsGenre.find(:all, :conditions => ["genre_id = ?", params[:id]] )	
	@tracks = TracksGenre.find(:all, :conditions => ["genre_id = ?", params[:id]] )
		
	if  @tracks.length.zero? && @albums.length.zero?
  
      @genre = Genre.find(params[:id])
      @genre.destroy
	  
	else
	  flash[:notice] = 'Genre could not be deleted, genre is in use in some albums or tracks'
	end
	

    respond_to do |format|
      format.html { redirect_to(genres_url) }
    end
  end
end
