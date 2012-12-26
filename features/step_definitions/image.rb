Before '@mock_s3' do
  @stub = stub_request(:put, /#{Settings.aws.bucket}\.s3\.amazonaws\.com/)
end


###
# Given step definitions
###

Given /^I am on the edit page for the image$/ do
  port = Capybara.current_session.driver.app_server.port
  visit edit_admin_image_url(@image, subdomain: :admin, host: 'lvh.me', port: port)
end


###
# When step definitions
###

When /^I attach an image file$/ do
  begin
    attach_file 'image_original', File.join('lib', 'sample-images', 'pikachu.png')
  rescue Capybara::Poltergeist::ObsoleteNode
    # https://github.com/jonleighton/poltergeist/issues/115
    nil
  end
end

When /^I start the upload$/ do
  click_button "Start"
  wait_until(60) { find('.template-download .name') rescue nil }
end


###
# Then step definitions
###

Then /^it should contain the file$/ do
  Image.where(original_file_name: 'pikachu.png').should have(1).model
end

Then /^the image file should be uploaded to S3$/ do
  # 7 files are uploaded: original + 6 styles
  @stub.should have_been_requested.times(7)
end

Then /^it should not show an upload error$/ do
  page.should have_no_css('.template-download .error')
end

Then /^I should see a listing of images sorted by creation date$/ do
  Image.order("created_at DESC").each_with_index do |image, i|
    page.find("tr:nth-child(#{i + 1})").text
      .should include(image.original_file_name)
  end
end

Then /^they should have the thumbnail versions$/ do
  @images.each do |image|
    image_selector = "img[src=\"#{image.original.url(:thumb_rect)}\"]"
    image_row(image).should have_css(image_selector)
  end
end

Then /^they should have links to image edit pages$/ do
  @images.each do |image|
    image_row(image).should have_link(image.original_file_name,
                                      href: edit_admin_image_path(image))
  end
end

Then /^they should have links to delete images$/ do
  @images.each do |image|
    image_row(image).should have_link('Delete', href: admin_image_path(image))
  end
end

Then /^I should see the fields with image information$/ do
  find_field('Caption').value.should == @image.caption
  find_field('Location').value.should == @image.location
  find_field('Photographer').value.should == @image.photographer.name
  find_field('image_created_at_1i').value.should == @image.created_at.year.to_s
  find_field('image_created_at_2i').value.should == @image.created_at.month.to_s
  find_field('image_created_at_3i').value.should == @image.created_at.day.to_s
end

When /^I make valid changes to the image$/ do
  @image.caption = "Ash goes into hiding in Johto."
  @image.location = "Mt. Silver"
  @image.photographer = Photographer.new(name: 'Youngster Todd')

  fill_in 'Caption', with: @image.caption
  fill_in 'Location', with: @image.location
  fill_in 'Photographer', with: @image.photographer.name
end

Then /^the image should have the correct properties$/ do
  image = Image.find(@image.id)
  image.caption.should == @image.caption
  image.location.should == @image.location
  image.photographer.should == Photographer.find_by_name('Youngster Todd')
  image.created_at.should == @image.created_at.to_date
end


###
# Helpers
###

def image_row(image)
  page.find("tr#image_#{image.id}")
end
