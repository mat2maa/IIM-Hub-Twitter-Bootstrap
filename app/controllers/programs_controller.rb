class ProgramsController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @programs = Program.find(:all, :order=>"name asc")	
	respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @program = Program.find(params[:id])
  end

  def new
    @program = Program.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @program = Program.new params[:program]
      if @program.save
        flash[:notice] = 'Program was successfully created.'        
        format.html  { redirect_to(programs_path) }
		    format.js
      else
      end
    end
  end
  
  def update
    @program = Program.find(params[:id])

    respond_to do |format|
      if @program.update_attributes(params[:program])
        AudioPlaylist.update_all(["program_cache=?",@program.name],["program_id=?",@program.id] )
        flash[:notice] = 'Program was successfully updated.'
        format.html { redirect_to(programs_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	  id = params[:id]
		@audio_playlists = AudioPlaylist.find(:all, :conditions => ["program_id = ?", id] )
		if @audio_playlists.length.zero?  
      @program = Program.find(id)
      @program.destroy
		else
			flash[:notice] = 'Program could not be deleted, program is in use in some tracks'
		end

    respond_to do |format|
      format.html { redirect_to(programs_url) }
    end
  end
end
