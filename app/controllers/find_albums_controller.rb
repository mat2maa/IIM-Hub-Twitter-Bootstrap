class FindAlbumsController < ApplicationController
  before_filter :require_user
	filter_access_to :all

  def find_albums
  
    sort = case params['sort']
           when "title_original"  then "title_original"
		   when "artist_original"  then "artist_original"
		   when "label"  then "labels.name"
		   when "year"  then "release_year"
		   when "cd_code"  then "cd_code"
		   when "title_original_reverse"  then "title_original DESC"
		   when "artist_original_reverse"  then "artist_original DESC"
		   when "label_reverse"  then "label DESC"		   
		   when "year_reverse"  then "release_year DESC"
		   when "cd_code_reverse"  then "cd_code DESC"
    end
	
    if params['title'].strip.length > 0
		@albums = Album.search(params['title'], [:title_original, :title_english, :artist_original, :artist_english, :cd_code, 'labels.name'], :joins => 'left join labels on labels.id=albums.label_id', :order => sort)
		
    end   
  end
  
  def index

    @search = Album.new_search(params[:search])
    @albums, @albums_count = @search.all, @search.count
  
  end
  
end
