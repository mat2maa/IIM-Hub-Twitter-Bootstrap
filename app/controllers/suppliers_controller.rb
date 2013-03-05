class SuppliersController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  before_filter only: [:index, :new] do
    @supplier = Supplier.new
  end

  def index
    #@suppliers = Supplier.find(:all, :order=>"company_name asc")	
    @search = Supplier.ransack(params[:q])
    @suppliers = @search.result(:distinct => true)
                        .paginate(page: params[:page], per_page: 10)
    @suppliers_count = @suppliers.count
    @search.build_condition
    
	  respond_to do |format|
      format.html # index.html.erb
      format.js  
    end
	
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @supplier = Supplier.new params[:supplier]

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to @supplier, notice: 'Supplier was successfully created.' }
        format.json { render json: @supplier, status: :created, location: @supplier }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
        format.js
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
		@movies = Movie.where("movie_distributor_id = ? OR laboratory_id = ? OR production_studio_id = ?", id,id,id)
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
