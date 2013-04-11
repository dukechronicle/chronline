require 'spec_helper'

describe PhotoshelterAPI do
  subject { PhotoshelterAPI.new(Settings.photoshelter.email, Settings.photoshelter.password) }

  context "when constructed with an invalid email" do
    it "should raise an error" do
      constructor = -> { PhotoshelterAPI.new("fail", Settings.photoshelter.password) }
      constructor.should raise_error(StandardError)
    end
  end

  context "when constructed with an invalid password" do
    it "should raise an error" do
      constructor = -> { PhotoshelterAPI.new(Settings.photoshelter.email, "fail") }
      constructor.should raise_error(StandardError)
    end
  end

  describe "#get_all_galleries" do
    it "should return list of galleries"
  end

  describe "#get_gallery_images" do
    it "should return a list of images for a gallery"
  end

  describe "#get_image_info" do
    it "should return information for an image"
  end

  describe "#logout" do
    it "should logout and destroy the session"
  end
end