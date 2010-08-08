class LanguagesController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @languages = Language.find(:all, :order=>"name asc")	
	respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @language = Language.find(params[:id])
  end

  def new
    @language = Language.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @language = Language.new params[:language]
      if @language.save
        flash[:notice] = 'Language was successfully created.'        
        format.html  { redirect_to(languages_path) }
		format.js
      else
      end
    end
  end
  
  def update
    @language = Language.find(params[:id])

    respond_to do |format|
      if @language.update_attributes(params[:language])
        Track.update_all(["language=?",@language.name],["language_id=?",@language.id] )
        
        flash[:notice] = 'Language was successfully updated.'
        format.html { redirect_to(languages_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	
	@tracks = Track.find(:all, :conditions => ["language_id = ?", params[:id]] )	
		
	if  @tracks.length.zero?
  
      @language = Language.find(params[:id])
      @language.destroy
	  
	else
	  flash[:notice] = 'Language could not be deleted, language is in use in some tracks'
	end



    respond_to do |format|
      format.html { redirect_to(languages_url) }
    end
  end
end
