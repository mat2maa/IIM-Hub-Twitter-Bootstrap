Feature: Video playlist types
  In order to manage video playlist types
  As an admin
  I want manage video playlist types

	Background:
		Given I am an authenticated "admin" user
	

	Scenario: View list of video playlist types
	  Given the following video_playlist_types exist:
	  | name   |
	  | type 1 |
	  | type 2 |
	  When I go to the path "/video_playlist_types"
	  Then I should see "type 1"
	  Then I should see "type 2"
	
	
	

  
