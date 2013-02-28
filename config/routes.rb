Iim::Application.routes.draw do


  root to: "dashboard#index"

  # probably refers to "my account", we'll need to handle it differently
  # resource :account, :controller => "users"

  resources :users do
    member do
      post 'enable'
      post 'disable'
    end
  end
  resource :user_session

  match "/account/edit_own_password" => "users#edit_own_password", as: :change_password
  match "/logout" => "user_sessions#destroy", as: :logout

  resources :password_resets

  resources :audio_playlists do
    member do
      post 'duplicate'
      post 'lock'
      post 'unlock'

      get 'zip', action: 'mp3', as: 'audio_playlist_zip'

    end
  end                                           #

  match "/add_to_playlist/:id" => "audio_playlists#add_track_to_playlist", as: :add_track_to_playlist
  match "/add_album_to_playlist/:id" => "album_playlists#add_album_to_playlist", as: :add_album_to_playlist
  match "/add_movie_to_playlist/:id" => "movie_playlists#add_movie_to_playlist", as: :add_movie_to_playlist
  match "/add_video_to_playlist/:id" => "video_playlists#add_video_to_playlist", as: :add_video_to_playlist
  match "/add_master_to_playlist/:id" => "video_master_playlists#add_master_to_playlist", as: :add_master_to_playlist
  match "/add_screener_to_playlist/:id" => "screener_playlists#add_screener_to_playlist", as: :add_screener_to_playlist

  match "/download_track_mp3/:id" => "audio_playlists#download_mp3", as: :download_tracks_mp3
  match "/download_album_mp3/:id" => "album_playlists#download_mp3", as: :download_album_tracks_mp3
  match "/edit_album_playlist_synopsis/:id" => "album_playlists#edit_synopsis", as: :edit_album_playlist_synopsis
  match "/export_by_airline" => "album_playlists#export_by_airline", as: :edit_album_playlist_synopsis
  match "/view_splits" => "audio_playlists#splits", as: :view_splits
  match "/movie_playlists/print/:id" => "movie_playlists#print", as: :print_movie_playlist

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
      post :duplicate
      post :lock
      post :unlock
    end
  end

  resources :album_playlist_items

  resources :movie_playlists do
    member do
      post :duplicate
      post :lock
      post :unlock
    end
    collection do
      put :add_multiple_movies
    end
  end

  # TODO convert these to nested style as above
  resources :movie_playlist_items
  resources :video_playlists, :member => {:duplicate => :post, :lock => :post, :unlock => :post},
            :collection => { :add_multiple_videos => :put }

  resources :video_playlist_items

  resources :video_master_playlists, :member => {:duplicate => :post, :lock => :post, :unlock => :post},
            :collection => { :add_multiple_masters => :put }

  resources :video_master_playlist_items

  resources :screener_playlists, :member => {:duplicate => :post, :lock => :post, :unlock => :post},
            :collection => { :add_multiple_screeners => :put }
  resources :screener_playlist_items

  resources :import_album, :collection => {:find_albums => :post,:cddb_import => :post, :update_album_mp3_exists => :post},
            :member => {:itunes_import => :post}

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

  resources :movies, :new => {:check_airline_rights => :post, :check_screener_remarks => :post,
                              :check_movie_type => :post, :update_date => :post}

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

  resources :masters, :member => {:duplicate => :post}
  resources :screeners, :member => {:duplicate => :post}


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
