###
# Given step definitions
###

Given /^there exists an? (\w+)$/ do |type|
  instance_variable_set("@#{type}", FactoryGirl.create(type))
end

Given /^there exist (\d+) (\w+)$/ do |n, collection|
  models = FactoryGirl.create_list(collection.singularize, n.to_i)
  instance_variable_set("@#{collection}", models)
end

Given /^I am on the (\w+) (\w+) page$/ do |action, collection|
  visit url_for(action: action,
                controller: "admin/#{collection.pluralize}",
                subdomain: :admin,
                port: Capybara.current_session.driver.app_server.port,
                host: 'lvh.me')
end


###
# Then step definitions
###

Then /^I should see (\d+) (\w+) listed$/ do |n, collection|
  page.all('tr').should have(n.to_i).rows
end
