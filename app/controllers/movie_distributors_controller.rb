class MovieDistributorsController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @movie_distributors = MovieDistributor.find(:all, :order=>"name asc")	
	  respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @movie_distributor = MovieDistributor.find(params[:id])
  end

  def new
    @movie_distributor = MovieDistributor.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @movie_distributor = MovieDistributor.new params[:movie_distributor]
      if @movie_distributor.save
        flash[:notice] = 'MovieDistributor was successfully created.'        
        format.html  { redirect_to(movie_distributors_path) }
		    format.js
      else
      end
    end
  end
  
  def update
    @movie_distributor = MovieDistributor.find(params[:id])

    respond_to do |format|
      if @movie_distributor.update_attributes(params[:movie_distributor])
        #Movie.update_all(["movie_distributor_cache=?",@movie_distributor.name],["movie_distributor_id=?",@movie_distributor.id] )
        flash[:notice] = 'MovieDistributor was successfully updated.'
        format.html { redirect_to(movie_distributors_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	  id = params[:id]
		@movies = Movie.find(:all, :conditions => ["movie_distributor_id = ?", id] )
		if @movies.length.zero?  
      @movie_distributor = MovieDistributor.find(id)
      @movie_distributor.destroy
		else
			flash[:notice] = 'MovieDistributor could not be deleted, movie_distributor is in use in some tracks'
		end

    respond_to do |format|
      format.html { redirect_to(movie_distributors_url) }
    end
  end
end
