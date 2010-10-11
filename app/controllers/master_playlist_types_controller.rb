class MasterPlaylistTypesController < ApplicationController
  before_filter :require_user
  filter_access_to :all

  def index
    @master_playlist_types = MasterPlaylistType.find(:all, :order=>"name asc")
    respond_to do |format|
      format.html # index.html.erb
    end

  end

  def edit
    @master_playlist_type = MasterPlaylistType.find(params[:id])
  end

  def new
    @master_playlist_type = MasterPlaylistType.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    respond_to do |format|
      @master_playlist_type = MasterPlaylistType.new params[:master_playlist_type]
      if @master_playlist_type.save
        flash[:notice] = 'MasterPlaylistType was successfully created.'
        format.html  { redirect_to(master_playlist_types_path) }
        format.js
      else
      end
    end
  end

  def update
    @master_playlist_type = MasterPlaylistType.find(params[:id])

    respond_to do |format|
      if @master_playlist_type.update_attributes(params[:master_playlist_type])
        #Movie.update_all(["master_playlist_type_cache=?",@master_playlist_type.name],["master_playlist_type_id=?",@master_playlist_type.id] )
        flash[:notice] = 'MasterPlaylistType was successfully updated.'
        format.html { redirect_to(master_playlist_types_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy

    id = params[:id]
    @master_playlists = VideoMasterPlaylistItem.find(:all, :conditions => ["master_playlist_type_id = ?", id] )
    if @master_playlists.length.zero? 
      @master_playlist_type = MasterPlaylistType.find(id)
      @master_playlist_type.destroy
    else
      flash[:notice] = 'MasterPlaylistType could not be deleted, master_playlist_type is in use'
    end

    respond_to do |format|
      format.html { redirect_to(master_playlist_types_url) }
    end
  end
end
