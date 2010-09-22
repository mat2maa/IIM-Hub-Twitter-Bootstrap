Feature: Screeners
  In order to manage screeners
 	As an admin or video producer
  I want to manage screeners

	Background:
		Given I am an authenticated "admin" user
		
	Scenario: View list of screeners
	  Given the following screeners exist:
		 | id | episode_title   | episode_number | location |
		 | 1  | Tom and Jerry 1 | ep 1           | 111      |
		 | 2  | Tom and Jerry 2 | ep 2           | 222      |
		 | 3  | Tom and Jerry 3 | ep 3           | 333      |
	  When I go to the path "/screeners"	
	  Then I should see "Tom and Jerry 1" 
	  And I should see "Tom and Jerry 2" 
	  And I should see "Tom and Jerry 3" 
	  And I should see "ep 1" 
	  And I should see "ep 2" 
	  And I should see "ep 3" 
	  And I should see "111" 
	  And I should see "222" 
	  And I should see "333" 
	
	# Scenario: Edit screener
	# 	  Given the following screeners exist:
	# 		 | id | episode_title   | episode_number | location |
	# 		 | 1  | Tom and Jerry 1 | ep 1           | 111      |
	# 		 | 2  | Tom and Jerry 2 | ep 2           | 222      |
	# 	  When I go to the path "/screeners"
	# 		And show me the page
	# 		And I follow "Edit"
	# 	  Then I should see "Edit Screener"
	# 	
	# 		When I fill in the following:
	# 		|Episode Title| Tom and Jane 1|
	# 		And press "Update Screener"
	# 		Then I should see "Successfully updated screener."
		
	Scenario: View list of screener playlists
	  Given the following screener_playlists exist:
		 | airline_id | start_cycle | end_cycle |
		 | 1          | 1/1/2010    | 1/2/2010  |
	  When event
	  Then outcome
