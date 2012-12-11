Given /^I am on the new article page$/ do
  port = Capybara.current_session.driver.app_server.port
  page.visit new_admin_article_url(subdomain: :admin, host: 'lvh.me', port: port)
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |field, value|
  page.fill_in field, with: value
end

When /^I click "(.*?)"$/ do |button|
  page.click_button button
end

Then /^the "(.*?)" field should show an error$/ do |field|
  # TODO: extend poltergeist node to give parent
  #  page.find_field(field).native.parent.parent
  #    .get_attribute(:class).should include('error')
end

Then /^the "(.*?)" field should be set to "(.*?)"$/ do |field, value|
  find_field(field).value.should == value
end
