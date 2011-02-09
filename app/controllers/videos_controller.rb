class VideosController < ApplicationController
  before_filter :require_user
  filter_access_to :all
  
  def index    
    if !params['search'].nil? 
      if !params[:language].nil?
        #before search
        if params[:language][:track]!="" && params[:language][:subtitle]==""
          @search = Video.with_language_track(params[:language][:track]).new_search(params[:search])      
        elsif params[:language][:subtitle]!="" && params[:language][:track]=="" && !params[:language].nil?
          @search = Video.with_language_subtitle(params[:language][:subtitle]).new_search(params[:search])      
        elsif params[:language][:subtitle]!="" && params[:language][:track]!="" && !params[:language].nil?
          @search = Video.with_language_subtitle(params[:language][:subtitle]).with_language_track(params[:language][:track]).new_search(params[:search])      
        else
          @search = Video.new_search(params[:search])
          @search.conditions.programme_title_keywords = params[:search][:conditions][:programme_title_keywords] 
          #@search.conditions.or_foreign_language_title_keywords = params[:search][:conditions][:programme_title_keywords] 
        end
      else      
        @search = Video.new_search(params[:search])
      end

    else 
      @search = Video.new_search(:order_by => :id, :order_as => "DESC")
    end
    @search.conditions.screeners_count_gte = params[:screeners].to_i if params[:screeners]=='1'
    @search.conditions.masters_count_gte = params[:masters].to_i if params[:masters]=='1'
    
    @videos, @videos_count = @search.all, @search.count
  
    if @videos_count == 1
      redirect_to(edit_video_path(@videos.first))
    end
    
    session[:videos_search] = collection_to_id_array(@videos)
    
  end


  def show
    @video = Video.find(params[:id])
  end

  def new
      @video_genres = VideoParentGenre.find(:all)
      
      
      @video = Video.new
      if !params[:video_type].nil?
        @video.movie_id=params[:id]
        @video.video_type=CGI.unescape(params[:video_type]) 
        if @video.video_type == "Movie EPK" || @video.video_type == "Movie Master" || @video.video_type == "TV Special" || @video.video_type == "Movie Trailer"
          movie = Movie.find(@video.movie_id)
          
          @existing_video = Video.find(:first, :conditions => ["programme_title=? AND video_type=?", movie.movie_title, @video.video_type])
          
          if !@existing_video.nil?
            redirect_to edit_video_path(@existing_video)
          end
          
          @video.programme_title = movie.movie_title
          @video.foreign_language_title = movie.foreign_language_title
          @video.video_distributor = movie.movie_distributor
          @video.production_studio = movie.production_studio
          @video.laboratory_id = movie.laboratory_id
          @video.language_tracks = movie.language_tracks        
          @video.language_subtitles = movie.language_subtitles        
          @video.synopsis = movie.synopsis     
        else
          @video.language_tracks = ["En"]   
        end
      else
        @video.language_tracks = ["En"]
      end
      @video.production_year = Date.today.year
      
      if @video.video_type == "Movie Master"
        #@video.screeners.build
        @video.masters.build
      end 
      
      master = Master.find(:first, :conditions => "location IS NOT NULL", :order => "location DESC", :limit => 1)
      if !master.nil?
        @master_location = master.location + 1
      else
        @master_location = 0 
      end
  end

  def create

    @video = Video.new(params[:video])
    @video_genres = VideoParentGenre.find(:all)

    @video.programme_title = @video.programme_title.upcase
    @video.foreign_language_title = @video.foreign_language_title.upcase if !@video.foreign_language_title.nil?

    # if production studio is empty, set it to the same as movie distributor supplier
    if @video.production_studio_id.nil? 
      count_suppliers = SupplierCategory.count('supplier_id', :include => :suppliers, :conditions => ["supplier_id = ? and supplier_categories.name = ? ", @video.video_distributor_id, "Production Studios"]) 
      @video.production_studio_id = @video.video_distributor_id if !count_suppliers.zero?
    end
    
    if @video.laboratory_id.nil? 
      count_suppliers = SupplierCategory.count('supplier_id', :include => :suppliers, :conditions => ["supplier_id = ? and supplier_categories.name = ? ", @video.video_distributor_id, "Laboratories"]) 
      @video.laboratory_id = @video.video_distributor_id if !count_suppliers.zero?
    end

#    respond_to do |format|
      if @video.save
        flash[:notice] = 'Video was successfully created.'
        redirect_to edit_video_path(@video)
      else
        render :action => 'new'
      end
 #   end
  end

  def edit
    @search = Video.new_search
    @videos, @videos_count = @search.all, @search.count
      
    @video = Video.find(params[:id])
    @video_genres = VideoParentGenre.find(:all)
    if !session[:videos_search].nil?
      ids = session[:videos_search] 
      id = ids.index(params[:id].to_i)
      if !id.nil?
        @next_id = ids[id+1] if (id+1 < ids.count)
        @prev_id = ids[id-1] if (id-1 >= 0)
      end
    end
      
    master = Master.find(:first, :conditions => "location IS NOT NULL", :order => "location DESC", :limit => 1)
    
    if !master.nil?
      @master_location = master.location + 1
    else
      @master_location = 0 
    end
    
  end

  def update     
    @video_genres = VideoParentGenre.find(:all)
    
    @video = Video.find(params[:id])
    params[:video][:programme_title] = params[:video][:programme_title].upcase
    params[:video][:foreign_language_title] = params[:video][:foreign_language_title].upcase if !params[:video][:foreign_language_title].nil?

    if @video.update_attributes(params[:video])
      flash[:notice] = "Successfully updated video."
      redirect_to edit_video_path(@video)
    else
      render :action => 'edit'
    end
  end

  def destroy

    @video = Video.find(params[:id])
    
    #check if video is in any playlists
    tot_playlists = VideoPlaylistItem.count(:conditions => 'video_id=' + @video.id.to_s )
    tot_master_playlists = VideoMasterPlaylistItem.count(:conditions => ["master_id IN (?)", @video.masters ])
    tot_screener_playlists = ScreenerPlaylistItem.count(:conditions => ["screener_id IN (?)", @video.screeners ])
    
    
    if tot_playlists.zero? && tot_master_playlists.zero? && tot_screener_playlists.zero?
      if permitted_to? :admin_delete, :videos  
        @video.destroy
        flash[:notice] = "Successfully deleted video."
        @video_is_deleted = true
      else
         @video.to_delete = true
         @video.save(false)
         flash[:notice] = 'Video will be deleted when approved by administrator'
         @video_is_deleted = false
      end
	  else
      flash[:notice] = 'Video could not be deleted, video is in use by playlists'
    	@video_is_deleted = false
    end
        
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.js
    end
    
  end  
  
  def restore
    @video = Video.find(params[:id])
    @video.to_delete = false
    @video.save(false)
    flash[:notice] = 'Video has been restored'
    respond_to do |format|
        format.html { redirect_to(:back) }
        format.js
    end
  end

end
