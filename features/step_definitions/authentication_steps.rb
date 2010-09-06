Given /^I am not authenticated$/ do
  visit('/logout') # ensure that at least
end

Given /^I am an authenticated "([^\"]*)" user$/ do |role|
  
  user = Factory(role)

  And %{I go to path "/"}
  And %{I fill in "Login" with "#{user.login}"}
  And %{I fill in "Password" with "password"}
  And %{I press "Login"}
  Then %{I should see "Dashboard"}
  
end