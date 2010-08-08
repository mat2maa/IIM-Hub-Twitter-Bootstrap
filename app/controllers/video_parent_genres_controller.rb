class VideoParentGenresController < ApplicationController
    before_filter :require_user
  	filter_access_to :all

    def index
      @video_parent_genres = VideoParentGenre.find(:all, :order=>"name asc")	
  	  respond_to do |format|
        format.html # index.html.erb
      end

    end

    def edit
      @video_parent_genre = VideoParentGenre.find(params[:id])
    end

    def new
      @video_parent_genre = VideoParentGenre.new

      respond_to do |format|
        format.html # new.html.erb
      end
    end

    def create
  	respond_to do |format|
        @video_parent_genre = VideoParentGenre.new params[:video_parent_genre]
        if @video_parent_genre.save
          flash[:notice] = 'VideoParentGenre was successfully created.'        
          format.html  { redirect_to(video_parent_genres_path) }
  		    format.js
        else
        end
      end
    end

    def update
      @video_parent_genre = VideoParentGenre.find(params[:id])

      respond_to do |format|
        if @video_parent_genre.update_attributes(params[:video_parent_genre])
          #Movie.update_all(["video_parent_genre_cache=?",@video_parent_genre.name],["video_parent_genre_id=?",@video_parent_genre.id] )
          flash[:notice] = 'VideoParentGenre was successfully updated.'
          format.html { redirect_to(video_parent_genres_path) }
        else
          format.html { render :action => "edit" }
        end
      end
    end

    def destroy

  	  id = params[:id]
  		@videos = VideoGenre.find(:all, :conditions => ["video_parent_genre_id = ?", id] )
  		if @videos.length.zero?  
        @video_genre = VideoParentGenre.find(id)
        @video_genre.destroy
  		else
  			flash[:notice] = 'Genre could not be deleted as it contains subcategories'
  		end

      respond_to do |format|
        format.html { redirect_to(video_parent_genres_url) }
      end
    end
  end

