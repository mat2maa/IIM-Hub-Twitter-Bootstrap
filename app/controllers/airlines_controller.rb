class AirlinesController < ApplicationController
  before_filter :require_user
  filter_access_to :all


  def index
    @airlines = Airline.find(:all, :order=>"name")
    #@airlines = Airline.all_cached
    respond_to do |format|
      format.html # index.html.erb
    end

  end

  def edit
    @airline = Airline.find(params[:id])
  end

  def new
    @airline = Airline.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @airline }
    end
  end

  def create
    respond_to do |format|
      @airline = Airline.new params[:airline]
      if @airline.save
        flash[:notice] = 'Airline was successfully created.'        
        format.html  { redirect_to(airlines_path) }
        format.js
      else
      end
    end
  end

  def update
    @airline = Airline.find(params[:id])

    respond_to do |format|
      if @airline.update_attributes(params[:airline])
        AudioPlaylist.update_all(["airline_cache=?",@airline.name],["airline_id=?",@airline.id] )

        flash[:notice] = 'Airline was successfully updated.'
        format.html { redirect_to(airlines_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy

    id = params[:id]

    @audio_playlists = AudioPlaylist.find(:all, :conditions => ["airline_id = ?", id] )
    @album_playlists = AlbumPlaylist.find(:all, :conditions => ["airline_id = ?", id] )

    if @audio_playlists.length.zero? && @album_playlists.length.zero?
      @airline = Airline.find(id)
      @airline.destroy
    else
      flash[:notice] = 'Airline could not be deleted, airline is in use in some playlists'
    end

    respond_to do |format|
      format.html { redirect_to(airlines_url) }
    end
  end

end
