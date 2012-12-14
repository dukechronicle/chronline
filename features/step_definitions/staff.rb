###
# Given step definitions
###

Given /^I am on the new staff page$/ do
  port = Capybara.current_session.driver.app_server.port
  visit new_admin_staff_url(subdomain: :admin, host: 'lvh.me', port: port)
end


When /^I enter a valid author$/ do
  @author = FactoryGirl.build(:author)
  select @author.type, from: "Type"
  fill_in 'Name', with: @author.name
  fill_in 'Affiliation', with: @author.affiliation
  fill_in 'Tagline', with: @author.tagline
  fill_in 'Twitter', with: @author.twitter
  check 'Current Columnist?' if @author.columnist
end

Then /^the author should have the correct properties$/ do
  author = Author.find_by_name @author.name
  author.affiliation.should == @author.affiliation
  author.tagline.should == @author.tagline
  author.twitter.should == @author.twitter
  author.columnist.should == @author.columnist
end
