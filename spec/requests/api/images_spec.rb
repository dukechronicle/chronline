require 'spec_helper'

describe "Images API" do
  before(:all) { @user = FactoryGirl.create(:user) }
  after(:all) { @user.destroy }

  shared_examples_for "an image response" do
    it "should have image properties" do
      attrs = ActiveSupport::JSON.decode(image.to_json)
      should include(attrs)
    end

    it "should match Camayak spec" do
      should include(
        'caption' => image.caption,
        'location' => image.location,
        'credit' => image.credit,
        'original_file_name' => image.original_file_name,
        'original_content_type' => image.original_content_type,
        'original_file_size' => image.original_file_size,
        'original_updated_at' => image.original_updated_at.iso8601,
        'created_at' => image.created_at.iso8601,
        'updated_at' => image.updated_at.iso8601,
        'photographer_id' => image.photographer_id,
        'published_url' => image.original.url
      )
    end
  end

  describe "GET /images" do
    before do
      stub_request(:put, /#{ENV['AWS_S3_BUCKET']}\.s3\.amazonaws\.com/)
      @images = FactoryGirl.create_list(:image, 3)
    end
    subject { response }
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    let(:image) { Image.find(res.first['id']) }

    context "when page 1 is fetched" do
      before do
        get api_images_url(subdomain: :api, page: 1, limit: 2)
      end
      its(:status) { should be(Rack::Utils.status_code(:ok)) }
      it { res.should be_an(Array) }
      it { res.should have(2).images }

      it "should have thumbnail url" do
        res.first.should include(
          "thumbnail_url" => image.thumbnail_url)
      end

      it_should_behave_like "an image response" do
        subject { res.first }
      end
    end

    context "when page 2 is fetched" do
      before do
        get api_images_url(subdomain: :api, page: 2, limit: 2)
      end

      its(:status) { should be(Rack::Utils.status_code(:ok)) }
      it { res.should be_an(Array) }
      it { res.should have(1).images }

      it "should have thumbnail url" do
        res.first.should include(
          "thumbnail_url" => image.thumbnail_url)
      end

      it_should_behave_like "an image response" do
        subject { res.first }
      end
    end
  end

  describe "GET /images/:id" do
    before do
      stub_request(:put, /#{ENV['AWS_S3_BUCKET']}\.s3\.amazonaws\.com/)
      @image = FactoryGirl.create(:image)
      get api_image_url(@image, subdomain: :api)
    end
    subject { response }

    its(:status) { should == Rack::Utils.status_code(:ok) }

    it_should_behave_like "an image response" do
      subject { ActiveSupport::JSON.decode(response.body) }
      let(:image) { @image }
    end
  end

  describe "POST /images" do
    let(:image_attrs) do
      attrs = FactoryGirl.attributes_for(:image)
      attrs[:photographer_id] = FactoryGirl.create(:staff).id
      attrs
    end
    subject { response }

    it "should require authentication" do
      expect { post api_images_url(subdomain: :api), image_attrs }.
        to require_authorization
    end

    context "when properly authenticated" do
      before do
        post api_images_url(subdomain: :api), image_attrs,
          'HTTP_AUTHORIZATION' => http_auth(@user)
      end

      its(:status) { should == Rack::Utils.status_code(:created) }

      it_should_behave_like "an image response" do
        subject { ActiveSupport::JSON.decode(response.body) }
        let(:image) { Image.find(subject['id']) }
      end
    end
  end

  describe "PUT /image/:id" do
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    let!(:image) { FactoryGirl.create :image }
    subject { response }

    it "should require authentication" do
      expect{ put api_image_url(image.id, subdomain: :api) }.
        to require_authorization
    end

    describe "with valid data" do
      let(:valid_attrs) { {caption: "The rare Pidgey in its natural habitat" } }
      before do
        put api_image_url(image.id, subdomain: :api), valid_attrs,
          'HTTP_AUTHORIZATION' => http_auth(@user)
      end

      its(:status) { should == Rack::Utils.status_code(:no_content) }
      it "should have a changed caption" do
        image.reload.caption.should == valid_attrs[:caption]
      end
    end

    describe "with invalid data" do
      let(:invalid_attrs) { {date: ""} }
      before do
        put api_image_url(image.id, subdomain: :api), invalid_attrs,
          'HTTP_AUTHORIZATION' => http_auth(@user)
      end
      it { response.status.should == Rack::Utils.status_code(:unprocessable_entity) }
      it "should respond with validation errors" do
        res.should include('date')
      end
    end
  end

  describe "DELETE /image/:id" do
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }
    let!(:image) { FactoryGirl.create :image }

    it "should require authentication" do
      expect{ delete api_image_url(image.id, subdomain: :api) }.
        to require_authorization
    end

    context "when properly authenticated" do
      before do
        delete api_image_url(image.id, subdomain: :api), nil,
          { 'HTTP_AUTHORIZATION' => http_auth(@user) }
      end

      it "should remove the image record" do
        Image.should have(:no).records
      end
      its(:status) { should == Rack::Utils.status_code(:no_content) }
    end
  end
end
