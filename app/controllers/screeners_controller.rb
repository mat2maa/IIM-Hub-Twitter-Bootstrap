class ScreenersController < ApplicationController
  before_filter :require_user
  filter_access_to :all
  
  def index    
    if !params['search'].nil? 
      @search = Screener.new_search(params[:search])
    else
      #no search made yet
      @search = Screener.new_search(:order_by => :id, :order_as => "DESC")
    end
    @screeners, @screeners_count = @search.all, @search.count
    
    if @screeners_count == 1
      redirect_to(edit_screener_path(@screeners.first))
    end
    
    session[:screeners_search] = collection_to_id_array(@screeners)
  end
  
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
    if !params['search'].nil? 
      @search = Screener.new_search(params[:search])
    else
      #no search made yet
      @search = Screener.new_search(:order_by => :id, :order_as => "DESC")
    end
    @screeners, @screeners_count = @search.all, @search.count
    
    if !session[:screeners_search].nil?
      ids = session[:screeners_search] 
      id = ids.index(params[:id].to_i)
      if !id.nil?
        @next_id = ids[id+1] if (id+1 < ids.count)
        @prev_id = ids[id-1] if (id-1 >= 0)
      end
    end
    
    @screener = Screener.find(params[:id])  
    respond_to do |format|
      format.js {render :layout => false}    
      format.html {}    
    end    
  end

  
  def update 
    
    @screener = Screener.find(params[:id])
    
    if @screener.update_attributes(params[:screener])      
      respond_to do |format|    
        format.html { 
          flash[:notice] = "Successfully updated screener."
          redirect_to edit_screener_url(@screener.id) 
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
    
    #check if video is in any playlists
    tot_playlists =VideoScreenerPlaylistItem.count(:conditions => 'screener_id=' + @screener.id.to_s )
    
    if tot_playlists.zero?
      if permitted_to? :admin_delete, :screeners
        @screener.destroy
        flash[:notice] = "Successfully deleted screener."
        @screener_is_deleted = true
      end
	  else
      flash[:notice] = 'Screener could not be deleted, screener is in use by playlists'
    	@screener_is_deleted = false
    end	
    
    respond_to do |format|    
      format.html { redirect_to edit_video_url(@screener.video.id) } 
      format.js {render :layout => false}
    end
  end
end
