class SupplierCategoriesController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def index
    @category = SupplierCategory.new  
    @categories = SupplierCategory.find(:all, :order=>"name asc")	
	  respond_to do |format|
      format.html # index.html.erb
    end
	
  end
  

  def new
    @category = SupplierCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end
  
  def create
	respond_to do |format|
      @category = SupplierCategory.new params[:supplier_category]
      if @category.save
        flash[:notice] = 'Category was successfully created.'        
        format.html  { redirect_to(supplier_categories_url) }
		    format.js
      else
      end
    end
  end
  
  def edit
    @category = SupplierCategory.find(params[:id])
  end
  
  def update
    @category = SupplierCategory.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:supplier_category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(supplier_categories_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
	
	count = Supplier.count(:from => :supplier_categories_suppliers, :conditions => ["supplier_category_id=?", params[:id]])	
		
	if  count.zero?
	  
      @category = SupplierCategory.find(params[:id])
      @category.destroy
	  
	else
	  flash[:notice] = 'Category could not be deleted, category is in use in some suppliers'
	end

    respond_to do |format|
      format.html { redirect_to(supplier_categories_url) }
    end
  end
end
