require 'spec_helper'

describe "Images API" do

  describe "GET /images" do
    before do
      stub_request(:put, /#{Settings.aws.bucket}\.s3\.amazonaws\.com/)
      @images = FactoryGirl.create_list(:image, 10)
      get api_images_url(subdomain: :api)
    end

    let(:success) { 200 }

    subject { JSON.parse(response.body) }

    it { response.status.should be(success) }
    it { should be_an(Array) }
    it { should have(10).images }
  end
end
