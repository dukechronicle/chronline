###
# Given step definitions
###

Given /^I am on the new staff page$/ do
  port = Capybara.current_session.driver.app_server.port
  visit new_admin_staff_url(subdomain: :admin, host: 'lvh.me', port: port)
end
