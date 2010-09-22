Feature: Masters
  In order to manage the masters and masters playlists
  As an administrator
  I want add, edit, delete masters and their playlists
	
	Background:
		Given I am an authenticated "admin" user

  Scenario: View masters
    Given the following masters exist:
		 | id | episode_title   | episode_number | location |
		 | 1  | Tom and Jerry 1 | ep 1           | 111      |
		 | 2  | Tom and Jerry 2 | ep 2           | 222      |
		 | 3  | Tom and Jerry 3 | ep 3           | 333      |
    When I go to path "/masters"	
	  Then I should see "TOM AND JERRY 1" 
	  And I should see "TOM AND JERRY 2" 
	  And I should see "TOM AND JERRY 3" 
	  And I should see "ep 1" 
	  And I should see "ep 2" 
	  And I should see "ep 3" 
	  And I should see "111" 
	  And I should see "222" 
	  And I should see "333" 
  
  
  
