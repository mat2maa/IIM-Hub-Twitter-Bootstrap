class RightsController < ApplicationController
  before_filter :require_user
  filter_access_to :all

  def index
    @search = Right.ransack(params[:q])
    @rights = @search.result(distinct: true)
    .paginate(page: params[:page],
              per_page: 10)
    @rights_count = @rights.count
  end

  def new
    @right = Right.new
  end

  def create
    @right = Right.new(params[:right])
    if @right.save
      flash[:notice] = "Right created"
      respond_to do |format|
        format.html { redirect_to(rights_path) }
        format.js
      end
    else
      render action: :new
    end
  end

  def edit
    @right = Right.find(params[:id])
  end

  def update
    @right = Right.find(params[:id]) # makes our views "cleaner" and more consistent
    if @right.update_attributes(params[:right])
      flash[:notice] = "Right updated!"
      redirect_to rights_path
    else
      render action: :edit
    end
  end

  def destroy
    @right = Right.find(params[:id])
    @right.destroy
    flash[:notice] = 'Right successfully destroyed.'
    redirect_to rights_path
  end
end
