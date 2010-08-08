class CommercialRunTimesController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @commercial_run_times = CommercialRunTime.find(:all, :order=>"minutes asc")	
	  respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @commercial_run_time = CommercialRunTime.find(params[:id])
  end

  def new
    @commercial_run_time = CommercialRunTime.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @commercial_run_time = CommercialRunTime.new params[:commercial_run_time]
      if @commercial_run_time.save
        flash[:notice] = 'CommercialRunTime was successfully created.'        
        format.html  { redirect_to(commercial_run_times_path) }
		    format.js
      else
      end
    end
  end
  
  def update
    @commercial_run_time = CommercialRunTime.find(params[:id])

    respond_to do |format|
      if @commercial_run_time.update_attributes(params[:commercial_run_time])
        flash[:notice] = 'CommercialRunTime was successfully updated.'
        format.html { redirect_to(commercial_run_times_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	  id = params[:id]
		@videos = Video.find(:all, :conditions => ["commercial_run_time_id = ?", id] )
		if @videos.length.zero?  
      @commercial_run_time = CommercialRunTime.find(id)
      @commercial_run_time.destroy
		else
			flash[:notice] = 'CommercialRunTime could not be deleted, commercial_run_time is in use in some tracks'
		end
		
    @commercial_run_time.destroy

    respond_to do |format|
      format.html { redirect_to(commercial_run_times_url) }
    end
  end
end
