class UserSessionsController < ApplicationController
	before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
    
  def index
  end
  
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    
    user_session_params = params[:user_session]
    if User.exists?(:enabled=>true, :login=>user_session_params[:login])
      if @user_session.save
        flash[:notice] = "Login successful!"
        redirect_back_or_default root_path
      else
        render :action => :new
      end
    else
      flash[:notice] = "Login does not exist"
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to new_user_session_url
  end
end
