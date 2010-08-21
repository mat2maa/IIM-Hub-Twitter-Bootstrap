class MastersController < ApplicationController
  def new  
    @master = Master.new
    @master.video_id = params[:id]
    respond_to do |format|
      format.js {render :layout => false}    
    end
  end
  
  def create
    
    @master = Master.new(params[:master])  
    
    if @master.save
        respond_to do |format|
          flash[:notice] = "Successfully created master."
          format.html { redirect_to edit_cms_video_url(@master.video) }  
          format.js {render :layout => false}
        end
      else
        respond_to do |format|
          format.html { render :action => 'new' }
          format.js { render :action => 'error.js.erb' } 
        end
      end
  end
  
  def edit
    @master = Master.find(params[:id])  
    respond_to do |format|
      format.js {render :layout => false}    
    end    
  end
  
  def update 
    
    @master = Master.find(params[:id])
    
    
    if @master.update_attributes(params[:master])      
      respond_to do |format|    
        format.html { 
          flash[:notice] = "Successfully updated master."
          redirect_to edit_cms_video_url(@master.video.id) 
        } 
        format.js {render :layout => false}
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.js { render :action => 'error.js.erb' } 
      end
    end
  end
  
  def destroy
    @master = Master.find(params[:id])
    
    @master.destroy
    flash[:notice] = "Successfully deleted master."
    
    respond_to do |format|    
      format.html { redirect_to edit_cms_video_url(@master.video.id) } 
      format.js {render :layout => false}
    end
  end
end
