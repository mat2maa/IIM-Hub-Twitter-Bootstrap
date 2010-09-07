class ScreenersController < ApplicationController
  def new
    @screener = Screener.new
    @screener.video_id = params[:id]
    respond_to do |format|
      format.js {render :layout => false}    
    end
  end
  
  def create
    
    @screener = Screener.new(params[:screener])  
    
    if @screener.save
        respond_to do |format|
          flash[:notice] = "Successfully created screener."
          format.html { redirect_to edit_cms_video_url(@screener.video) }  
          format.js {render :layout => false}
        end
      else
        respond_to do |format|
          format.html { render :action => 'new' }
          format.js { render :action => 'error.js.erb', :layout => false } 
        end
      end
  end
  
  def edit
    @screener = Screener.find(params[:id])  
    respond_to do |format|
      format.js {render :layout => false}    
    end
  end
  
  def update 
    
    @screener = Screener.find(params[:id])
    
    if @screener.update_attributes(params[:screener])      
      respond_to do |format|    
        format.html { 
          flash[:notice] = "Successfully updated screener."
          redirect_to edit_cms_video_url(@screener.video.id) 
        } 
        format.js {render :layout => false}
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.js { render :action => 'error.js.erb', :layout => false } 
      end
    end
  end
  
  def destroy
    @screener = Screener.find(params[:id])
    
    @screener.destroy
    flash[:notice] = "Successfully deleted screener."
    
    respond_to do |format|    
      format.html { redirect_to edit_cms_video_url(@screener.video.id) } 
      format.js {render :layout => false}
    end
  end
end
