ActionController::Routing::Routes.draw do |map|
	
	map.resource :account, :controller => "users"
  map.resources :users
  map.resource :user_session
  map.change_password '/account/edit_own_password', :controller=>"users", :action=>"edit_own_password"
	map.logout 'logout', :controller => "user_sessions", :action => "destroy"
	map.resources :password_resets
	
	map.root :controller => "dashboard"
	
	map.audio_playlist_zip 'audio_playlists/:id/zip', :controller => 'audio_playlists', :action => 'mp3'
  map.add_track_to_playlist '/add_track_to_playlist/:id', :controller => 'audio_playlists', :action => 'add_track_to_playlist'
  map.add_album_to_playlist '/add_album_to_playlist/:id', :controller => 'album_playlists', :action => 'add_album_to_playlist'
  map.add_movie_to_playlist '/add_movie_to_playlist/:id', :controller => 'movie_playlists', :action => 'add_movie_to_playlist'
  map.add_video_to_playlist '/add_video_to_playlist/:id', :controller => 'video_playlists', :action => 'add_video_to_playlist'
  map.add_master_to_playlist '/add_master_to_playlist/:id', :controller => 'video_master_playlists', :action => 'add_master_to_playlist'
  map.add_screener_to_playlist '/add_screener_to_playlist/:id', :controller => 'screener_playlists', :action => 'add_screener_to_playlist'
	map.download_tracks_mp3 '/download_track_mp3/:id', :controller => 'audio_playlists', :action => 'download_mp3'
	map.download_album_tracks_mp3 '/download_album_mp3/:id', :controller => 'album_playlists', :action => 'download_mp3'
  map.edit_album_playlist_synopsis '/edit_album_playlist_synopsis/:id', :controller => 'album_playlists', :action => 'edit_synopsis'
  map.export_by_airline '/export_by_airline', :controller => 'album_playlists', :action => 'export_by_airline'
  map.view_splits '/view_splits', :controller => 'audio_playlists', :action=>'splits'
  map.print_movie_playlist '/movie_playlists/print/:id', :controller => 'movie_playlists', :action => 'print'

  map.resources :roles
  map.resources :rights
  map.resources :splits 
	map.resources :vo_durations 
  map.resources :airlines
  map.resources :programs
  map.resources :genres
  map.resources :labels
  map.resources :audio_playlists, :member => {:duplicate => :post, :lock => :post, :unlock => :post} 
  map.resources :audio_playlist_tracks
  map.resources :album_playlists, :member => {:duplicate => :post, :lock => :post, :unlock => :post}
  map.resources :album_playlist_items 
  map.resources :movie_playlists, :member => {:duplicate => :post, :lock => :post, :unlock => :post}, 
    :collection => { :add_multiple_movies => :put }
  
  map.resources :movie_playlist_items
  map.resources :video_playlists, :member => {:duplicate => :post, :lock => :post, :unlock => :post}, 
    :collection => { :add_multiple_videos => :put }
  
  map.resources :video_playlist_items
  
  map.resources :video_master_playlists, :member => {:duplicate => :post, :lock => :post, :unlock => :post}, 
    :collection => { :add_multiple_masters => :put }
  
  map.resources :video_master_playlist_items

  map.resources :screener_playlists, :member => {:duplicate => :post, :lock => :post, :unlock => :post}, 
    :collection => { :add_multiple_screeners => :put }  
  map.resources :screener_playlist_items
  
  map.resources :import_album, :collection => {:find_albums => :post,:cddb_import => :post, :update_album_mp3_exists => :post},  
    :member => {:itunes_import => :post}    
  
  map.resources :publishers
  map.resources :vos
  map.resources :settings
  map.resources :albums
  map.resources :tracks  
  map.resources :languages    
  map.resources :master_languages    
  map.resources :origins  
  map.resources :categories    
  map.resources :supplier_categories    
  map.resources :find_albums 
  map.resources :find_songs 
  
  map.resources :movies, :new => {:check_airline_rights => :post, :check_screener_remarks => :post, 
    :check_movie_type => :post, :update_date => :post}
  
  map.resources :suppliers
  map.resources :airline_rights_countries
  map.resources :movie_genres
  map.resources :video_genres
  map.resources :video_parent_genres
  map.resources :movies_settings
  map.resources :videos
  map.resources :commercial_run_times
  map.resources :video_playlist_types
  map.resources :master_playlist_types
  
  map.resources :masters, :member => {:duplicate => :post} 
  map.resources :screeners, :member => {:duplicate => :post} 
  
        
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
