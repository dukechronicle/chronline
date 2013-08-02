require 'spec_helper'

describe "Images API" do

  describe "GET /images/*" do
    let(:success) { 200 }
    let(:no_response) { 204 }
    subject { response }

    before do
      stub_request(:put, /#{Settings.aws.bucket}\.s3\.amazonaws\.com/)
      @image = FactoryGirl.create(:image)
    end

    describe "get all images" do
      before do
        get api_images_url(subdomain: :api)
      end
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
        images.first.should include(
          "thumbnail_url" => @image.original.url(:thumb_rect))
      end
    end

    describe "get single image" do
      before { get api_image_url(subdomain: :api, id: @image.id) }
      let(:image) { JSON.parse(response.body) }

      its(:status) { should == success }
      it "should have have image properties" do
        attrs = @image.attributes
        # Timestamps are in different format for JSON
        attrs.each do |key, value|
          if value.respond_to?(:iso8601)
            attrs[key] = value.iso8601
          end
        end
        image.should include(attrs)
      end
    end
  end
  describe "DELETE /image/*" do
    let(:res) { JSON.decode(response.body) }
    subject { response }
    let!(:staff) { FactoryGirl.create :staff }
    it { change(Staff, :count).by(1) }
  end
end
