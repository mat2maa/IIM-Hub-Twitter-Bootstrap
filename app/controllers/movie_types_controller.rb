class MovieTypesController < ApplicationController
  # GET /movie_types
  # GET /movie_types.json
  def index
    @movie_types = MovieType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movie_types }
    end
  end

  # GET /movie_types/1
  # GET /movie_types/1.json
  def show
    @movie_type = MovieType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie_type }
    end
  end

  # GET /movie_types/new
  # GET /movie_types/new.json
  def new
    @movie_type = MovieType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie_type }
    end
  end

  # GET /movie_types/1/edit
  def edit
    @movie_type = MovieType.find(params[:id])
  end

  # POST /movie_types
  # POST /movie_types.json
  def create
    @movie_type = MovieType.new(params[:movie_type])

    respond_to do |format|
      if @movie_type.save
        format.html { redirect_to @movie_type, notice: 'Movie type was successfully created.' }
        format.json { render json: @movie_type, status: :created, location: @movie_type }
      else
        format.html { render action: "new" }
        format.json { render json: @movie_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movie_types/1
  # PUT /movie_types/1.json
  def update
    @movie_type = MovieType.find(params[:id])

    respond_to do |format|
      if @movie_type.update_attributes(params[:movie_type])
        format.html { redirect_to @movie_type, notice: 'Movie type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movie_types/1
  # DELETE /movie_types/1.json
  def destroy
    @movie_type = MovieType.find(params[:id])
    @movie_type.destroy

    respond_to do |format|
      format.html { redirect_to movie_types_url }
      format.json { head :no_content }
    end
  end
end
