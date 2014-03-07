require 'spec_helper'

# TODO: remove additional authentication in each test

describe PhotoshelterAPI do

  describe "authenticate" do

    context "when authenticated with an invalid email" do
      use_vcr_cassette 'bad_username'

      it "raises PhotoshelterError" do
        constructor = -> { PhotoshelterAPI.new.authenticate }
        constructor.should raise_error(PhotoshelterAPI::PhotoshelterError)
      end
    end

    context "when authenticated with an invalid password" do
      use_vcr_cassette "bad_password"

      it "raises PhotoshelterError" do
        constructor = -> { PhotoshelterAPI.new.authenticate }
        constructor.should raise_error(PhotoshelterAPI::PhotoshelterError)
      end
    end

    context "when authenticated with correct credentials" do
      use_vcr_cassette 'authentication'

      it "authenticates properly" do
        @response = PhotoshelterAPI.new.authenticate
        @response.should == true
      end
    end
  end

  describe "authenticated routes" do

    subject(:photoshelterapi) do
      PhotoshelterAPI.new
    end

    describe "GET galleries" do
      use_vcr_cassette 'galleries'

      it "returns list of galleries" do
        @response = photoshelterapi.get_all_galleries
        @response.should be_a Array
      end
    end

    describe "GET gallery images" do
      use_vcr_cassette 'images'

      it "returns a list of images for a gallery" do
        @response = photoshelterapi.get_gallery_images "G0000W3g4oBchl8c"
        @response.should be_a Array
      end
    end

    describe "GET image info" do
      use_vcr_cassette 'info'

      it "returns information for an image" do
        @response = photoshelterapi.get_image_info "I0000P1V4eGUln18"
        @response.should be_a Hash

        keys = @response.keys
        keys.should include "title"
        keys.should include "author"
        keys.should include "caption"
      end
    end

    describe "GET logout" do
      use_vcr_cassette 'logout'

      it "logs out and destroys the session" do
        @response = photoshelterapi.logout
        expect { photoshelterapi.get_image_info}.to raise_error
      end
    end
  end
end
