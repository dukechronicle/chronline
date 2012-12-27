###
# Given step definitions
###

Given /^there exists an article with authors$/ do
  @article = FactoryGirl.create(:article_with_authors)
end


###
# When step definitions
###

When /^I enter a valid article$/ do
  @article = FactoryGirl.build(:article)
  fill_in 'Title', with: @article.title
  fill_in 'Subtitle', with: @article.subtitle
  fill_in 'Teaser', with: @article.teaser
  fill_in 'Body', with: @article.body
  select @article.section[0], from: 'article_section_0'
  select @article.section[1], from: 'article_section_1'
  select (@article.section[2] || ''), from: 'article_section_2'
end

When /^I make valid changes to the article$/ do
  @article.subtitle = "Starter Pokemon already taken"
  @article.teaser = "Ash arrived too late"
  @article.body = "**Pikachu** wrecks everyone."
  @article.section = "/sports/"

  fill_in 'Subtitle', with: @article.subtitle
  fill_in 'Teaser', with: @article.teaser
  fill_in 'Body', with: @article.body
  select @article.section[0], from: 'article_section_0'
end

When /^I go to the original edit article path$/ do
  visit @path
end

When /^I add author "(.*?)"$/ do |name|
  @article.authors << Author.new(name: name)
  fill_in 'article_author_ids_0', with: name
end

When /^I click an article delete link$/ do
  click_link "Delete"
  @article = (@articles - Article.all).first
end


###
# Then step definitions
###

Then /^the article should have the correct properties$/ do
  article = Article.find_by_title @article.title
  article.subtitle.should == @article.subtitle
  article.teaser.should == @article.teaser
  article.section.should == @article.section
  article.body.should == @article.body
  article.authors.map(&:name).should == @article.authors.map(&:name)
end

Then /^I should see a listing of articles sorted by creation date$/ do
  Article.order("created_at DESC").each_with_index do |article, i|
    page.find("tr:nth-child(#{i + 1})").text.should include(article.title)
  end
end

Then /^they should have links to edit pages$/ do
  @articles.each do |article|
    article_row(article)
      .should have_link('Edit', href: edit_admin_article_path(article))
  end
end

Then /^they should have links to delete them$/ do
  @articles.each do |article|
    article_row(article)
      .should have_link('Delete', href: admin_article_path(article))
  end
end

Then /^I should see the fields with article information$/ do
  confirm_field_values('Title' => @article.title,
                       'Subtitle' => @article.subtitle,
                       'Teaser' => @article.teaser,
                       'Body' => @article.body,
                       'article_author_ids_0' => @article.authors[0].name,
                       'article_author_ids_1' =>  @article.authors[1].name,
                       'article_section_0' => @article.section[0],
                       'article_section_1' => @article.section[1],
                       'article_section_2' => @article.section[2] || '',
                       )
end

Then /^I should see an article deletion success message$/ do
  confirm_alert(:success, "Article \"#{@article.title}\" was deleted")
end

Then /^I should be on the edit article page$/ do
  Article.find(@article.id) do |article|
    current_path.should == edit_admin_article_path(article)
  end
end


###
# Helpers
###

def article_row(article)
  page.find("tr#article_#{article.id}")
end
