#compare tables
Then(/^I should see (.+) table$/) do |model, expected_table|
  html_table = tableish("table##{model} tr", "th,td" ).to_a
  expected_table.diff!(html_table)
end
