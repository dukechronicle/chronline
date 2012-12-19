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
  stub = stub_request(:put, /#{Settings.aws.bucket}\.s3\.amazonaws\.com/)
  click_button "Start"
  wait_until { find('.template-download .preview') rescue nil }
  stub.should have_been_requested
end
