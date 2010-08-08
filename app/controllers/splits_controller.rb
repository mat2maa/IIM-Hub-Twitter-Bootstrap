class SplitsController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @splits = Split.find(:all, :order=>"duration")
	  respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @split = Split.find(params[:id])
  end

  def new
    @split = Split.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @split }
    end
  end
  
  def create    
    
	  respond_to do |format|
      @split = Split.new params[:split]
      @split.more_than = (params[:more_than_min].to_i * 60  *1000) + (params[:more_than_sec].to_i * 1000)
      @split.less_than = (params[:less_than_min].to_i * 60  *1000) + (params[:less_than_sec].to_i * 1000)
      
      if @split.save
        flash[:notice] = 'Split was successfully created.'        
        format.html  { redirect_to(splits_path) }
		    format.js
      else
      end
    end
  end
  
  def update
    @split = Split.find(params[:id])

    respond_to do |format|
      if @split.update_attributes(params[:split])
        @split.more_than = (params[:more_than_min].to_i * 60  *1000) + (params[:more_than_sec].to_i * 1000)
        @split.less_than = (params[:less_than_min].to_i * 60  *1000) + (params[:less_than_sec].to_i * 1000)
        @split.save
        flash[:notice] = 'Split was successfully updated.'
        format.html { redirect_to(splits_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
      @split = Split.find(params[:id])
      @split.destroy
	  
    respond_to do |format|
      format.html { redirect_to(splits_url) }
    end
  end
end
