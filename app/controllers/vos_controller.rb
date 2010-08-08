class VosController < ApplicationController
  before_filter :require_user
  filter_access_to :all

  def index
    @vos = Vo.find(:all, :order=>"name asc")	
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def edit
    @vo = Vo.find(params[:id])
  end

  def new
    @vo = Vo.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    respond_to do |format|
      @vo = Vo.new params[:vo]
      if @vo.save
        flash[:notice] = 'Vo was successfully created.'        
        format.html  { redirect_to(vos_path) }
        format.js
      else
      end
    end
  end

  def update
    @vo = Vo.find(params[:id])

    respond_to do |format|
      if @vo.update_attributes(params[:vo])
        flash[:notice] = 'Vo was successfully updated.'
        format.html { redirect_to(vos_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy


    @playlists = AudioPlaylist.find(:all, :conditions => ["vos.id = ?", params[:id]], :include=>:vo )	

    if  @playlists.length.zero?

      @vo = Vo.find(params[:id])
      @vo.destroy

    else
      flash[:notice] = 'VO could not be deleted, VO is in use in a playlist'
    end

    respond_to do |format|
      format.html { redirect_to(vos_url) }
    end
  end
end
