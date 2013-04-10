require 'spec_helper'

describe PhotoshelterAPI do
  subject { PhotoshelterAPI.new(Settings['photoshelter']['email'], Settings['photoshelter']['password']) }

  context "when constructed with an invalid email" do
    it "should raise an error" do
      constructor = lambda { PhotoshelterAPI.new("fail", Settings['photoshelter']['password']) }
      constructor.should raise_error(StandardError)
    end
  end

  context "when constructed with an invalid password" do
    it "should raise an error" do
      constructor = lambda { PhotoshelterAPI.new(Settings['photoshelter']['email'], "fail") }
      constructor.should raise_error(StandardError)
    end
  end

# To test
# galleries = api.get_all_galleries
# images = api.get_gallery_images galleries.first["id"]
# puts api.get_image_info images.first["id"]
# api.logout

end