require 'spec_helper'

describe "Images API" do
  before(:all) { @user = FactoryGirl.create(:user) }
  after(:all) { @user.destroy }
  describe "GET /images/*" do
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

      it { response.status.should be(Rack::Utils.status_code(:ok)) }
      it { images.should be_an(Array) }
      it { images.should have(1).images }

      it "should have image properties" do
        attrs = json_attributes(@image)
        images.first.should include(attrs)
      end

      it "should have thumbnail url" do
        images.first.should include(
          "thumbnail_url" => @image.thumbnail_url)
      end
    end

    describe "get single image" do
      before { get api_image_url(subdomain: :api, id: @image.id) }
      let(:image) { JSON.parse(response.body) }
      let(:res) { ActiveSupport::JSON.decode(response.body) }

      its(:status) { should == Rack::Utils.status_code(:ok) }
      it "should have have image properties" do
        attrs = json_attributes(@image)
        image.should include(attrs)
      end
      it "should match Camayak spec" do
        res.should include(
          'caption' => @image.caption,
          'location' => @image.location,
          'credit' => @image.credit,
          'original_file_name' => @image.original_file_name,
          'original_content_type' => @image.original_content_type,
          'original_file_size' => @image.original_file_size,
          'original_updated_at' => @image.original_updated_at.iso8601,
          'created_at' => @image.created_at.iso8601,
          'updated_at' => @image.updated_at.iso8601,
          'photographer_id' => @image.photographer_id,
          'published_url' => @image.original.url
        )
      end
    end
  end

  describe "POST /images/" do
    let(:new_image) do
      convert_objs_to_ids(
        FactoryGirl.attributes_for(:image), :photographer, :photographer_id)
    end
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }

    it "should require authentication" do
      expect{ post api_images_url(subdomain: :api), new_image }.
        to require_authorization
    end

    before do
      post api_images_url(subdomain: :api), new_image,
        { 'HTTP_AUTHORIZATION' => http_auth(@user) }
    end

    its(:status) { should == Rack::Utils.status_code(:created) }

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
          { 'HTTP_AUTHORIZATION' => http_auth(@user) }
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
          { 'HTTP_AUTHORIZATION' => http_auth(@user) }
      end
      it { response.status.should == Rack::Utils.status_code(:unproccessable_entity) }
      it "should respond with validation errors" do
        res.should include('date')
      end
    end
  end

  describe "DELETE /image/:id" do
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }
    let!(:image) { FactoryGirl.create :image }
    before do
      delete api_image_url(image.id, subdomain: :api), nil,
        { 'HTTP_AUTHORIZATION' => http_auth(@user) }
    end

    it "should require authentication" do
      expect{ delete api_image_url(image.id, subdomain: :api) }.
        to require_authorization
    end

    it "should remove the image record" do
      Image.should have(:no).records
    end
    its(:status) { should == Rack::Utils.status_code(:no_content) }
  end
end

def convert_objs_to_ids(hash, key, new_key)
  if hash[key].respond_to? :each
    hash[new_key] = hash.delete(key).map { |obj| obj.id }
  else
    hash[new_key] = hash.delete(key).id
  end
  hash
end
