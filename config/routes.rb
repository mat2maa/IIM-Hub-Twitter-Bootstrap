Iim::Application.routes.draw do


  root to: "dashboard#index"

  # probably refers to "my account", we'll need to handle it differently
  # resource :account, :controller => "users"


  match "/account/edit_own_password" => "users#edit_own_password", as: :change_password
  match "/logout" => "user_sessions#destroy", as: :logout
  match "/add_track_to_playlist/:id" => "audio_playlists#add_track_to_playlist", as: :add_track_to_playlist
  match "/add_album_to_playlist/:id" => "album_playlists#add_album_to_playlist", as: :add_album_to_playlist
  match "/add_movie_to_playlist/:id" => "movie_playlists#add_movie_to_playlist", as: :add_movie_to_playlist
  match "/add_video_to_playlist/:id" => "video_playlists#add_video_to_playlist", as: :add_video_to_playlist
  match "/add_master_to_playlist/:id" => "video_master_playlists#add_master_to_playlist", as: :add_master_to_playlist
  match "/add_screener_to_playlist/:id" => "screener_playlists#add_screener_to_playlist", as: :add_screener_to_playlist
  match "/download_track_mp3/:id" => "audio_playlists#download_mp3", as: :download_tracks_mp3
  match "/download_album_mp3/:id" => "album_playlists#download_mp3", as: :download_album_tracks_mp3
  match "/edit_album_playlist_synopsis/:id" => "album_playlists#edit_synopsis", as: :edit_album_playlist_synopsis
  match "/export_by_airline" => "album_playlists#export_by_airline", as: :export_by_airline
  match "/view_splits" => "audio_playlists#splits", as: :view_splits
  match "/movie_playlists/print/:id" => "movie_playlists#print", as: :print_movie_playlist
  match "/audio_playlists/export_to_excel/:id" => "audio_playlists#export_to_excel", as: :export_to_excel
  match "/audio_playlists/print/:id" => "audio_playlists#print", as: :print
  match "/album_playlists/export_to_excel/:id" => "album_playlists#export_to_excel", as: :export_to_excel
  match "/album_playlists/print/:id" => "album_playlists#print", as: :print
  match "/albums/amazon_cd_covers" => "albums#amazon_cd_covers", as: :amazon_cd_covers

  resources :users do
    member do
      post 'enable'
      post 'disable'
    end
  end

  resources :password_resets

  resources :audio_playlists do
    member do
      post 'duplicate'
      post 'lock'
      post 'unlock'

      get 'zip', action: 'mp3', as: 'audio_playlist_zip'

    end
  end

  resource :user_session
  resources :roles
  resources :rights
  resources :splits
  resources :vo_durations
  resources :airlines
  resources :programs
  resources :genres
  resources :labels
  resources :audio_playlist_tracks

  resources :album_playlists do
    member do
      post 'duplicate'
      post 'lock'
      post 'unlock'
    end
    collection do
      post 'export_albums_programmed_per_airline_to_excel'
    end
  end

  resources :album_playlist_items

  resources :movie_playlists do
    member do
      post 'duplicate'
      post 'lock'
      post 'unlock'
    end
    collection do
      put 'add_multiple_movies'
    end
  end

  resources :movie_playlist_items

  resources :video_playlists do
    member do
      post 'duplicate'
      post 'lock'
      post 'unlock'
    end
    collection do
      put 'add_multiple_videos'
      end
  end

  resources :video_playlist_items

  resources :video_master_playlists do
    member do
      post 'duplicate'
      post 'lock'
      post 'unlock'
    end
    collection do
      put 'add_multiple_masters'
    end
  end

  resources :video_master_playlist_items

  resources :screener_playlists do
    member do
      post 'duplicate'
      post 'lock'
      post 'unlock'
    end
    collection do
      put 'add_multiple_screeners'
    end
  end

  resources :screener_playlist_items

  resources :import_album do
    member do
      post 'itunes_import'
    end
    collection do
      post 'find_albums'
      post 'cddb_import'
      post 'update_album_mp3_exists'
    end
  end

  resources :publishers
  resources :vos
  resources :settings
  resources :albums
  resources :tracks
  resources :languages
  resources :master_languages
  resources :origins
  resources :categories
  resources :supplier_categories
  resources :find_albums
  resources :find_songs

  resources :movies do
    new do
      post 'check_airline_rights'
      post 'check_screener_remarks'
      post 'check_movie_type'
      post 'update_date'
    end
  end

  resources :suppliers
  resources :airline_rights_countries
  resources :movie_genres
  resources :video_genres
  resources :video_parent_genres
  resources :movies_settings
  resources :videos
  resources :commercial_run_times
  resources :video_playlist_types
  resources :master_playlist_types

  resources :masters do
    member do
      post 'duplicate'
    end
  end

  resources :screeners do
    member do
      post 'duplicate'
    end
  end



  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
