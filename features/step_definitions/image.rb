Given /^there exist (\d+) images$/ do |n|
  stub_request(:put, /#{Settings.aws.bucket}\.s3\.amazonaws\.com/)
  @images = FactoryGirl.create_list(:image, n.to_i)
end

Given /^I am on the (\w+) (\w+) page$/ do |action, collection|
  visit url_for(action: action,
                controller: "admin/#{collection.pluralize}",
                subdomain: :admin,
                port: Capybara.current_session.driver.app_server.port,
                host: 'lvh.me')
end

When /^I attach an image file$/ do
  begin
    attach_file 'image_original', File.join('lib', 'sample-images', 'pikachu.png')
  rescue Capybara::Poltergeist::ObsoleteNode
    # https://github.com/jonleighton/poltergeist/issues/115
    nil
  end
end

When /^I start the upload$/ do
  @stub = stub_request(:put, /#{Settings.aws.bucket}\.s3\.amazonaws\.com/)
  click_button "Start"
  wait_until(60) { find('.template-download .name') rescue nil }
end

Then /^it should contain the file$/ do
  Image.where(original_file_name: 'pikachu.png').should have(1).model
end

Then /^the image file should be uploaded to S3$/ do
  @stub.should have_been_requested.times(6)
end

Then /^it should not show an upload error$/ do
  expect { find('.template-download .error') }.to raise_error(Capybara::ElementNotFound)
end

Then /^I should see a listing of images sorted by creation date$/ do
  Image.order("created_at DESC").each_with_index do |image, i|
    page.find("tr:nth-child(#{i + 1})").text
      .should include(image.original_file_name)
  end
end

Then /^they should have the thumbnail versions$/ do
  @images.each do |image|
    expect {page.find("tr img[src=#{image.original.url(:thumb_rect)}]")}
      .not_to raise_error(Capybara::ElementNotFound)
  end
end

Then /^they should have links to image edit pages$/ do
  @images.each do |image|
    row = page.find("tr#image_#{image.id}")
    row.should have_link(image.original_file_name,
                         href: edit_admin_image_path(image))
  end
end

Then /^they should have links to delete images$/ do
  @images.each do |image|
    row = page.find("tr#image_#{image.id}")
    row.should have_link('Delete', href: admin_image_path(image))
  end
end
