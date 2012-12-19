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

When /^I wait for upload to finish$/ do
  wait_until { find('.template-download .preview') rescue nil }
end
