Given /^I am on the image upload page$/ do
  port = Capybara.current_session.driver.app_server.port
  visit upload_admin_images_url(subdomain: :admin, host: 'lvh.me', port: port)
end

When /^I attach an image file$/ do
  begin
    attach_file 'image_original', 'lib/sample-images/pikachu.png'
  rescue Capybara::Poltergeist::ObsoleteNode
    # https://github.com/jonleighton/poltergeist/issues/115
    nil
  end
end

When /^I start the upload$/ do
  @stub = stub_request(:put, /#{Settings.aws.bucket}\.s3\.amazonaws\.com/)
  click_button "Start"
  wait_until { find('.template-download .name') rescue nil }
end

Then /^it should contain the file$/ do
  Image.where(original_file_name: 'pikachu.png').should have(1).model
end

Then /^the image file should be uploaded to S3$/ do
  @stub.should have_been_requested
end

Then /^it should not show an upload error$/ do
  expect { find('.template-download .error') }.to raise_error(Capybara::ElementNotFound)
end
