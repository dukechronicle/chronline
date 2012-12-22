require 'spec_helper'

describe "Images API" do

  describe "GET /images" do
    before do
      stub_request(:put, /#{Settings.aws.bucket}\.s3\.amazonaws\.com/)
      @image = FactoryGirl.create(:image)
      get api_images_url(subdomain: :api)
    end

    let(:success) { 200 }
    let(:images) { JSON.parse(response.body) }

    it { response.status.should be(success) }
    it { images.should be_an(Array) }
    it { images.should have(1).images }

    it "should have image properties" do
      attrs = @image.attributes
      # Timestamps are in different format for JSON
      attrs.each do |key, value|
        if value.respond_to?(:iso8601)
          attrs[key] = value.iso8601
        end
      end
      images.first.should include(attrs)
    end

    it "should have original url" do
      images.first.should include(url: @image.original.url)
    end
  end
end
