class AirlineRightsCountriesController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @airline_rights_countries = AirlineRightsCountry.find(:all, :order=>"name asc")	
	respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def new
    @airline_rights_country = AirlineRightsCountry.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @airline_rights_country = AirlineRightsCountry.new params[:airline_rights_country]
      if @airline_rights_country.save
        flash[:notice] = 'AirlineRightsCountry was successfully created.'        
        format.html  { redirect_to(airline_rights_countries_path) }
		    format.js
      else
      end
    end
  end
  
  def edit
     @airline_rights_country = AirlineRightsCountry.find(params[:id])
  end
  
  def update
    @airline_rights_country = AirlineRightsCountry.find(params[:id])

    respond_to do |format|
      if @airline_rights_country.update_attributes(params[:airline_rights_country])
        flash[:notice] = 'AirlineRightsCountry was successfully updated.'
        format.html { redirect_to(airline_rights_countries_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	  id = params[:id]
				
  	@albums = MoviesAirlineRightsCountry.find(:all, :conditions => ["airline_rights_country_id = ?", params[:id]] )	

		if @movies.length.zero?  
      @airline_rights_country = AirlineRightsCountry.find(id)
      @airline_rights_country.destroy
		else
			flash[:notice] = 'Airline Rights Country could not be deleted, airline_rights_country is in use by some movies'
		end

    respond_to do |format|
      format.html { redirect_to(airline_rights_countries_url) }
    end
  end
end
