class CategoriesController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @categories = Category.find(:all, :order=>"name asc", :conditions=>"id!=1")	
	respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  
  def edit
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end
  
  def create
	respond_to do |format|
      @category = Category.new params[:category]
      if @category.save
        flash[:notice] = 'Category was successfully created.'        
        format.html  { redirect_to(categories_path) }
		format.js
      else
      end
    end
  end
  
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(categories_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	
	@album_playlist_items = AlbumPlaylistItem.find(:all, :conditions => ["category_id = ?", params[:id]] )	
		
	if  @album_playlist_items.length.zero? || params[:id]==1
  
      @category = Category.find(params[:id])
      @category.destroy
	  
	else
	  flash[:notice] = 'Category could not be deleted, category is in use in some album playlist items'
	end

    respond_to do |format|
      format.html { redirect_to(categories_url) }
    end
  end
end
