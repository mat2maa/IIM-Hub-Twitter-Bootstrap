class MasterLanguagesController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @master_languages = MasterLanguage.find(:all, :order=>"name asc")	
	respond_to do |format|
      format.html # index.html.erb
    end

  end

  def edit
    @master_language = MasterLanguage.find(params[:id])
  end

  def new
    @master_language = MasterLanguage.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
	respond_to do |format|
      @master_language = MasterLanguage.new params[:master_language]
      if @master_language.save
        flash[:notice] = 'MasterLanguage was successfully created.'        
        format.html  { redirect_to(master_languages_path) }
		format.js
      else
      end
    end
  end

  def update
    @master_language = MasterLanguage.find(params[:id])
    
    @name = @master_language.name

    respond_to do |format|
      if @master_language.update_attributes(params[:master_language])
        
        Master.update_all(["language_track_1=?",@master_language.name],["language_track_1=?",@name] )
        Master.update_all(["language_track_2=?",@master_language.name],["language_track_2=?",@name] )
        Master.update_all(["language_track_3=?",@master_language.name],["language_track_3=?",@name] )
        Master.update_all(["language_track_4=?",@master_language.name],["language_track_4=?",@name] )
        
        Master.update_all(["video_subtitles_1=?",@master_language.name],["video_subtitles_1=?",@name] )
        Master.update_all(["video_subtitles_2=?",@master_language.name],["video_subtitles_2=?",@name] )

        Movie.update_all("language_tracks = REPLACE(language_tracks, '#{@name}','#{@master_language.name}')")
        Movie.update_all("language_subtitles = REPLACE(language_subtitles, '#{@name}','#{@master_language.name}')")

        Video.update_all("language_tracks = REPLACE(language_tracks, '#{@name}','#{@master_language.name}')")
        Video.update_all("language_subtitles = REPLACE(language_subtitles, '#{@name}','#{@master_language.name}')")

        flash[:notice] = 'MasterLanguage was successfully updated.'
        format.html { redirect_to(master_languages_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy

    @master_language = MasterLanguage.find(params[:id])
    
    @count = 0
  	@count  += Master.find(:all, :conditions => ["language_track_1 = ?", @master_language.name] ).count
  	@count  += Master.find(:all, :conditions => ["language_track_2 = ?", @master_language.name] ).count
  	@count  += Master.find(:all, :conditions => ["language_track_3 = ?", @master_language.name] ).count
  	@count  += Master.find(:all, :conditions => ["language_track_4 = ?", @master_language.name] ).count
  	@count  += Master.find(:all, :conditions => ["video_subtitles_1 = ?", @master_language.name] ).count
  	@count  += Master.find(:all, :conditions => ["video_subtitles_2 = ?", @master_language.name] ).count
  	
  	@count  += Movie.find(:all, :conditions => "language_tracks like '%#{@master_language.name}%'").count
  	@count  += Movie.find(:all, :conditions => "language_subtitles like '%#{@master_language.name}%'").count

  	@count  += Video.find(:all, :conditions => "language_tracks like '%#{@master_language.name}%'").count
  	@count  += Video.find(:all, :conditions => "language_subtitles like '%#{@master_language.name}%'").count


  	if  @count.zero?
  	  flash[:notice] = 'Language successfully deleted'
      @master_language.destroy
  	else
  	  flash[:notice] = 'Language could not be deleted, language is in use'
  	end

    respond_to do |format|
      format.html { redirect_to(master_languages_url) }
    end
  end
end

