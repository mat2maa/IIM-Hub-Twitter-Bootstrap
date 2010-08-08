namespace :db do
	desc "Delete and populate users and rights"
  task :populate => :environment do
		require 'populator'
    require 'faker'
    
    [User, Right, Role].each(&:delete_all)

	  #Create default users, roles and rights
		role = Role.create :name=>"administrator"
		
		user = User.new
		user.login = "super"
		user.password = "password"
		user.password_confirmation = "password"
		user.email = "angela@audioreload.com"
		
		user.roles << role
		user.save
		
		role.save
		
		role = Role.create :name=>"programmer"
		user = User.new
		user.login = "programmer"
		user.password = "password"
		user.password_confirmation = "password"
		user.email = "prog@audioreload.com"
		
		user.roles << role
		
		right = Right.create :name=> "View Settings", 
		  :controller=> "settings", :action=>"index"
		role.rights << right
		
		#user
		right = Right.create :name=> "Edit own password", 
		  :controller=> "users", :action=>"edit_own_password"
		role.rights << right
		
		right = Right.create :name=> "Update own password", 
		  :controller=> "users", :action=>"update_own_password"
		role.rights << right
		
		# airlines
		right = Right.create :name=> "View Airlines", 
		  :controller=> "airlines", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New Airlines", 
		  :controller=> "airlines", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Airlines", 
		  :controller=> "airlines", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Airlines", 
		  :controller=> "airlines", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Airlines", 
		  :controller=> "airlines", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete Airlines", 
		  :controller=> "airlines", :action=>"destroy"
		role.rights << right
		
		#programs
		right = Right.create :name=> "View Programs", 
		  :controller=> "programs", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New Programs", 
		  :controller=> "programs", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Programs", 
		  :controller=> "programs", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Programs", 
		  :controller=> "programs", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Programs", 
		  :controller=> "programs", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete Programs", 
		  :controller=> "programs", :action=>"destroy"
		role.rights << right
		
		#genres
		right = Right.create :name=> "View Genres", 
		  :controller=> "genres", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New Genres", 
		  :controller=> "genres", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Genres", 
		  :controller=> "genres", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Genres", 
		  :controller=> "genres", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Genres", 
		  :controller=> "genres", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete Genres", 
		  :controller=> "genres", :action=>"destroy"
		role.rights << right
		
		#labels
		right = Right.create :name=> "View Labels", 
		  :controller=> "labels", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New Labels", 
		  :controller=> "labels", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Labels", 
		  :controller=> "labels", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Labels", 
		  :controller=> "labels", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Labels", 
		  :controller=> "labels", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete Labels", 
		  :controller=> "labels", :action=>"destroy"
		role.rights << right
		
		#publishers
		right = Right.create :name=> "View Publishers", 
		  :controller=> "publishers", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New Publishers", 
		  :controller=> "publishers", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Publishers", 
		  :controller=> "publishers", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Publishers", 
		  :controller=> "publishers", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Publishers", 
		  :controller=> "publishers", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete Publishers", 
		  :controller=> "publishers", :action=>"destroy"
		role.rights << right
		
		#languages
		right = Right.create :name=> "View Languages", 
		  :controller=> "languages", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New Languages", 
		  :controller=> "languages", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Languages", 
		  :controller=> "languages", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Languages", 
		  :controller=> "languages", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Languages", 
		  :controller=> "languages", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete Languages", 
		  :controller=> "languages", :action=>"destroy"
		role.rights << right
		
		#origins
		right = Right.create :name=> "View Origins", 
		  :controller=> "origins", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New Origins", 
		  :controller=> "origins", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Origins", 
		  :controller=> "origins", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Origins", 
		  :controller=> "origins", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Origins", 
		  :controller=> "origins", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete Origins", 
		  :controller=> "origins", :action=>"destroy"
		role.rights << right
		
		#VOs
		right = Right.create :name=> "View VOs", 
		  :controller=> "vos", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New VOs", 
		  :controller=> "vos", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create VOs", 
		  :controller=> "vos", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit VOs", 
		  :controller=> "vos", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update VOs", 
		  :controller=> "vos", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete VOs", 
		  :controller=> "vos", :action=>"destroy"
		role.rights << right
		
		#categories
		right = Right.create :name=> "View Categories", 
		  :controller=> "categories", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New Categories", 
		  :controller=> "categories", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Categories", 
		  :controller=> "categories", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Categories", 
		  :controller=> "categories", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Categories", 
		  :controller=> "categories", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete Categories", 
		  :controller=> "categories", :action=>"destroy"
		role.rights << right
		
		#audio playlists
		right = Right.create :name=> "View Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "Show Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"show"
		role.rights << right
		
		right = Right.create :name=> "New Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"destroy"
		role.rights << right
		
		right = Right.create :name=> "Lock Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"lock"
		
		right = Right.create :name=> "Unlock Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"unlock"
		
		right = Right.create :name=> "Print Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"print"
		role.rights << right
		
		right = Right.create :name=> "Sort Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"sort"
		role.rights << right
		
		right = Right.create :name=> "Duplicate Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"duplicate"
		role.rights << right
		
		right = Right.create :name=> "Find Track Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"find_track"
		role.rights << right
		
		right = Right.create :name=> "Edit Audio Playlists Mastering", 
		  :controller=> "audio_playlists", :action=>"edit_audio_playlist_mastering"
		role.rights << right
		
		right = Right.create :name=> "Add Track", 
		  :controller=> "audio_playlists", :action=>"add_track_to_playlist"
		role.rights << right
		
		right = Right.create :name=> "Add Track to Playlist", 
		  :controller=> "audio_playlists", :action=>"add_track"
		role.rights << right
		
		right = Right.create :name=> "Export Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"export"
		role.rights << right
		
		right = Right.create :name=> "Export to Excel Audio Playlists", 
		  :controller=> "audio_playlists", :action=>"export_to_excel"
		role.rights << right
		
		right = Right.create :name=> "New Audio Playlist Tracks", 
		  :controller=> "audio_playlist_tracks", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Update Audio Playlist Tracks", 
		  :controller=> "audio_playlist_tracks", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Destroy Audio Playlist Tracks", 
		  :controller=> "audio_playlist_tracks", :action=>"destroy"
		role.rights << right
		
		
		#album playlists
		right = Right.create :name=> "View Album Playlists", 
		  :controller=> "album_playlists", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New Album Playlists", 
		  :controller=> "album_playlists", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Album Playlists", 
		  :controller=> "album_playlists", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Album Playlists", 
		  :controller=> "album_playlists", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Album Playlists", 
		  :controller=> "album_playlists", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Show Album Playlists", 
		  :controller=> "album_playlists", :action=>"show"
		role.rights << right
		
		right = Right.create :name=> "Print Album Playlists", 
		  :controller=> "album_playlists", :action=>"print"
		role.rights << right
		
		right = Right.create :name=> "Add Album to Playlists", 
		  :controller=> "album_playlists", :action=>"add_album_to_playlist"
		role.rights << right
		
		right = Right.create :name=> "Add Album - Album Playlists", 
		  :controller=> "album_playlists", :action=>"add_album"
		role.rights << right
		
		right = Right.create :name=> "Delete Album Playlists", 
		  :controller=> "album_playlists", :action=>"destroy"
		role.rights << right
		
		right = Right.create :name=> "Lock Album Playlists", 
		  :controller=> "album_playlists", :action=>"lock"
		
		right = Right.create :name=> "Unlock Album Playlists", 
		  :controller=> "album_playlists", :action=>"unlock"
		
		right = Right.create :name=> "Sort Album Playlists", 
		  :controller=> "album_playlists", :action=>"sort"
		role.rights << right
		
		right = Right.create :name=> "Edit Synopsis - Album Playlists", 
		  :controller=> "album_playlists", :action=>"edit_synopsis"
		role.rights << right
		
		right = Right.create :name=> "Export to Excel Album Playlists", 
		  :controller=> "album_playlists", :action=>"export_to_excel"
		role.rights << right
		
		right = Right.create :name=> "Export Album Playlists by Airline", 
		  :controller=> "album_playlists", :action=>"export_albums_programmed_per_airline_to_excel"
		role.rights << right
		
    # right = Right.create :name=> "Duration- Album Playlists", 
    #   :controller=> "album_playlists", :action=>"duration"
    # role.rights << right
    # 
    # right = Right.create :name=> "Convert to 2 digits Album Playlists", 
    #   :controller=> "album_playlists", :action=>"sort"
    # role.rights << right
		
		right = Right.create :name=> "Duplicate Album Playlists", 
		  :controller=> "album_playlists", :action=>"duplicate"
		role.rights << right
		
		right = Right.create :name=> "New Album Playlist Item", 
		  :controller=> "album_playlist_items", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Update Album Playlist Item Category ID", 
		  :controller=> "album_playlists", :action=>"set_album_playlist_item_category_id"
		role.rights << right
		
		right = Right.create :name=> "Destroy Album Playlist Item", 
		  :controller=> "album_playlist_items", :action=>"destroy"
		role.rights << right
		
		#albums
		right = Right.create :name=> "View Albums", 
		  :controller=> "albums", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New Albums", 
		  :controller=> "albums", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Albums", 
		  :controller=> "albums", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Albums", 
		  :controller=> "albums", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Albums", 
		  :controller=> "albums", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete Albums", 
		  :controller=> "albums", :action=>"destroy"
		role.rights << right
		
		right = Right.create :name=> "Import Albums - Index", 
		  :controller=> "import_album", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "Import Albums - Find Release", 
		  :controller=> "import_album", :action=>"find_release"
		role.rights << right
		
		right = Right.create :name=> "Import Albums - Import Release", 
		  :controller=> "import_album", :action=>"import_release"
		role.rights << right
		
		right = Right.create :name=> "Albums - View Amazon CD Covers", 
		  :controller=> "albums", :action=>"amazon_cd_covers"
		role.rights << right
		
		right = Right.create :name=> "Albums - Show Genre", 
		  :controller=> "albums", :action=>"show_genre"
		role.rights << right
		
		right = Right.create :name=> "Albums - Show Synopsis", 
		  :controller=> "albums", :action=>"show_synopsis"
		role.rights << right

		right = Right.create :name=> "Albums - Show Tracks", 
		  :controller=> "albums", :action=>"show_tracks"
		role.rights << right

		right = Right.create :name=> "Albums - Show Playlists", 
		  :controller=> "albums", :action=>"show_playlists"
		role.rights << right
		
		right = Right.create :name=> "Albums - Show Tracks translation", 
		  :controller=> "albums", :action=>"show_tracks_translation"
		role.rights << right
		
		right = Right.create :name=> "Albums - Sort Track", 
		  :controller=> "albums", :action=>"sort"
		
		right = Right.create :name=> "Albums - Restore", 
		  :controller=> "albums", :action=>"restore"

		
		#tracks
		right = Right.create :name=> "View Tracks", 
		  :controller=> "tracks", :action=>"index"
		role.rights << right
		
		right = Right.create :name=> "New Tracks", 
		  :controller=> "tracks", :action=>"new"
		role.rights << right
		
		right = Right.create :name=> "Create Tracks", 
		  :controller=> "tracks", :action=>"create"
		role.rights << right
		
		right = Right.create :name=> "Edit Tracks", 
		  :controller=> "tracks", :action=>"edit"
		role.rights << right
		
		right = Right.create :name=> "Update Tracks", 
		  :controller=> "tracks", :action=>"update"
		role.rights << right
		
		right = Right.create :name=> "Delete Tracks", 
		  :controller=> "tracks", :action=>"destroy"
		role.rights << right
		
		role.save
		user.save	
		
		role = Role.create :name=>"client"
		role.save
		
	end
end
