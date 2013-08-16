require 'spec_helper'

# TODO: remove additional authentication in each test

describe PhotoshelterAPI do

  subject { PhotoshelterAPI.new(Settings.photoshelter.email, Settings.photoshelter.password) }

  context "when authenticated with an invalid email" do
    it "should raise an error" do
      constructor = -> { PhotoshelterAPI.new("fail", Settings.photoshelter.password).authenticate }
      constructor.should raise_error(StandardError)
    end
  end

  context "when authenticated with an invalid password" do
    it "should raise an error" do
      constructor = -> { PhotoshelterAPI.new(Settings.photoshelter.email, "fail").authenticate }
      constructor.should raise_error(StandardError)
    end
  end

  describe "Authentication" do
    use_vcr_cassette "authentication"

    it "should authenticate properly" do
      subject.authenticate.should == true
    end
  end

  describe "GET galleries" do
    use_vcr_cassette "galleries"

    it "should return list of galleries" do
      subject.authenticate
      subject.get_all_galleries.should be_a Array
    end
  end

  describe "GET gallery images" do
    use_vcr_cassette "images"

    it "should return a list of images for a gallery" do
      subject.authenticate
      images = subject.get_gallery_images "G0000W3g4oBchl8c"
      images.should be_a Array
    end
  end

  describe "GET image info" do
    use_vcr_cassette "info"

    it "should return information for an image" do
      subject.authenticate
      info = subject.get_image_info "I0000P1V4eGUln18"
      info.should be_a Hash

      keys = info.keys
      keys.should include "title"
      keys.should include "author"
      keys.should include "caption"
    end
  end

  describe "GET logout" do
    use_vcr_cassette "logout"

    it "should logout and destroy the session" do
      subject.authenticate
      subject.logout
      expect { subject.get_image_info}.to raise_error
    end
  end
end
