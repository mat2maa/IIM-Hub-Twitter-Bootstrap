Feature: Masters
  In order to manage the masters and masters playlists
  As an administrator
  I want add, edit, delete masters and their playlists
	
	Background:
		Given I am an authenticated "admin" user

  Scenario: View masters
    Given the following masters exist:
		 | id | episode_title | episode_number | location |
		 | 1  | Tom and Jerry | 1              | 123      |
		 | 2  | Tom and Jerry | 2              | 123      |
		 | 3  | Tom and Jerry | 3              | 124      |
    When I go to path "/masters"		
  
  
  
