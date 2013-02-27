class UsersController < ApplicationController	 
  before_filter :require_user
	filter_access_to :all
  
  def index
    #conditions = params[:q]

    @search = User.ransack(params[:q])
    #if !params[:keywords].nil? && !params[:keywords].empty?
     # keywords = params[:keywords]
     # @search.conditions.or_login_keywords = keywords
    #end
    #
		#if !params[:q].nil?
		#	@search.per_page = conditions["per_page"]
		#	@search.page = conditions["page"]
		#	@search.order_as = conditions["order_as"]
		#	@search.order_by = conditions["order_by"]
		#end
    #
    @users = @search.result(:distinct => true)
    @users_count = @users.count
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default users_url
    else
      render :action => :new
    end
  end

  def show
    @user = User.find(params[:id])  
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
		
    @user = User.find(params[:id])
		
    if @user.update_attributes(params[:user])			
      flash[:notice] = "Account updated!"
      redirect_to users_path
    else
      render :action => :edit_own_password
    end
  end
	
	def edit_own_password
		@user = current_user
	end
	
	def update_own_password
		@user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Password updated!"
      redirect_to root_path
    else
      render :action => :edit
    end
	end
	
	def enable
		@user = User.find(params[:id])
		@user.enabled = true
		@user.save
		redirect_to :back
	end

	def disable
		@user = User.find(params[:id])
		@user.enabled = false
		@user.save
		redirect_to :back
	end
	
	def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

end
