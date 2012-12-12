Given /^I am on the new article page$/ do
  port = Capybara.current_session.driver.app_server.port
  visit new_admin_article_url(subdomain: :admin, host: 'lvh.me', port: port)
end

Given /^I am on the article index page$/ do
  port = Capybara.current_session.driver.app_server.port
  visit admin_articles_url(subdomain: :admin, host: 'lvh.me', port: port)
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |field, value|
 fill_in field, with: value
end

When /^I click "(.*?)"$/ do |button|
 click_button button
end

When /^I enter a valid article$/ do
  fill_in "Title", with: "Ash defeats Gary in Indigo Plateau"
  fill_in "Subtitle", with: "Oak arrives just in time"
  fill_in "Teaser", with: "Ash becomes new Pokemon Champion."
  fill_in "Body", with: "**Pikachu** wrecks everyone. The End."
  select "News", from: 'article_section_0'
  select "University", from: 'article_section_1'
end

Then /^the "(.*?)" field should show an error$/ do |field|
  find_field(field).find(:xpath, '../..')[:class].should include('error')
end

Then /^the "(.*?)" field should be set to "(.*?)"$/ do |field, value|
  find_field(field).value.should == value
end

Then /^a new Article should be created$/ do
  Article.count.should == 1
end

Then /^the article should have the correct properties$/ do
  article = Article.find_by_title "Ash defeats Gary in Indigo Plateau"
  article.subtitle.should == "Oak arrives just in time"
  article.teaser.should == "Ash becomes new Pokemon Champion."
  article.section.should == Taxonomy.new(['News', 'University'])
  article.body.should == "**Pikachu** wrecks everyone. The End."
end

Then /^I should see a listing of articles sorted by creation date$/ do
  Article.order("created_at DESC").each_with_index do |article, i|
    page.find("tr:nth-child(#{i + 1})").text.should include(article.title)
  end
end

Then /^they should have links to edit pages$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^they should have links to delete them$/ do
  pending # express the regexp above with the code you wish you had
end
