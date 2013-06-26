require 'spec_helper'

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
      # TODO: remove additional authentication here
      subject.authenticate
      subject.get_all_galleries.should be_a Array
    end
  end

  describe "GET gallery images" do
    it "should return a list of images for a gallery"
  end

  describe "GET image info" do
    it "should return information for an image"
  end

  describe "GET logout" do
    it "should logout and destroy the session"
  end
end