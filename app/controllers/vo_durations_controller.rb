class VoDurationsController < ApplicationController
 before_filter :require_user
 filter_access_to :all

  def index
    @vo_durations = VoDuration.find(:all, :order=>"duration")
	  respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @vo_duration = VoDuration.find(params[:id])
  end

  def new
    @vo_duration = VoDuration.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vo_duration }
    end
  end
  
  def create    
    
	  respond_to do |format|
      @vo_duration = VoDuration.new params[:vo_duration]      
      if @vo_duration.save
        flash[:notice] = 'VO Duration was successfully created.'        
        format.html  { redirect_to(vo_durations_path) }
		    format.js
      else
      end
    end
  end
  
  def update
    @vo_duration = VoDuration.find(params[:id])

    respond_to do |format|
      if @vo_duration.update_attributes(params[:vo_duration])
        flash[:notice] = 'VoDuration was successfully updated.'
        format.html { redirect_to(vo_durations_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
      @vo_duration = VoDuration.find(params[:id])
      @vo_duration.destroy
	  
    respond_to do |format|
      format.html { redirect_to(vo_durations_url) }
    end
  end
end
