class SuppliersController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    #@suppliers = Supplier.find(:all, :order=>"company_name asc")	
    @search = Supplier.new_search(params[:search])
    @suppliers, @suppliers_count = @search.all, @search.count
    
	  respond_to do |format|
      format.html # index.html.erb
      format.js  
    end
	
  end
  
  def edit
    @supplier = Supplier.find(params[:id])
  end

  def new
    @supplier = Supplier.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
	respond_to do |format|
      @supplier = Supplier.new params[:supplier]
      if @supplier.save
        flash[:notice] = 'Supplier was successfully created.'        
        format.html  { redirect_to(suppliers_path) }
		    format.js
      else
      end
    end
  end
  
  def update
    @supplier = Supplier.find(params[:id])

    respond_to do |format|
      if @supplier.update_attributes(params[:supplier])
        flash[:notice] = 'Supplier was successfully updated.'
        format.html { redirect_to(suppliers_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    
	  id = params[:id]
		@movies = Movie.find(:all, :conditions => ["supplier_id = ?", id] )
		if @movies.length.zero?  
      @supplier = Supplier.find(id)
      @supplier.destroy
		else
			flash[:notice] = 'Supplier could not be deleted, supplier is in use in some tracks'
		end

    respond_to do |format|
      format.html { redirect_to(suppliers_url) }
    end
  end
end
