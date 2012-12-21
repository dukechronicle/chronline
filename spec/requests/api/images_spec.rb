require 'spec_helper'

describe "Images API" do

  describe "GET /images" do
    before { get api_images_url(subdomain: :api) }

    let(:success) { 200 }
    let(:images) { FactoryGirl.create_list(:image, 10) }

    subject { JSON.parse(response.body) }

    it { response.status.should be(success) }

    it { should be_an(Array) }
    it { should have(10).images }
  end
end
