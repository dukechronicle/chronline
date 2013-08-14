require 'spec_helper'

describe "/staff/*" do
  before(:all) { @user = FactoryGirl.create(:user) }
  after(:all) { @user.destroy }
  subject { ActiveSupport::JSON.decode(response.body) }

  describe "GET /staff" do
    let!(:staff) do
      [
       FactoryGirl.create(:staff, name: 'Joe Smith'),
       FactoryGirl.create(:staff_with_image, name: 'John Smith'),
       FactoryGirl.create(:staff, name: 'Will Smith', columnist: true),
      ]
    end

    context "when page 1 is fetched" do
      before { get api_staff_index_url(subdomain: :api), page: 1, limit: 2 }

      it { response.status.should == Rack::Utils.status_code(:ok) }
      it { should have(2).staff }
    end

    context "when page 2 is fetched" do
      before { get api_staff_index_url(subdomain: :api), page: 2, limit: 2 }

      it { response.status.should == Rack::Utils.status_code(:ok) }
      it { should have(1).staff }
    end

    context "when search parameter is specified" do
      before { get api_staff_index_url(subdomain: :api), search: 'Jo' }

      it "should respond with staff with names matching search prefix" do
        subject.each { |result| result['name'].should start_with('Jo') }
      end
    end

    context "when columnist filter is true" do
      before { get api_staff_index_url(subdomain: :api), columnist: true }

      it "should return only columnists" do
        subject.each { |result| result['columnist'].should be_true }
      end
    end

    context "when columnist filter is false" do
      before { get api_staff_index_url(subdomain: :api), columnist: false }

      it "should return only columnists" do
        subject.each { |result| result['columnist'].should be_false }
      end
    end

    context "when photographer filter is true" do
      before { get api_staff_index_url(subdomain: :api), photographer: true }

      it "should return only photographers" do
        subject.each { |result| result['photographer'].should be_true }
      end
    end

    context "when photographer filter is false" do
      before { get api_staff_index_url(subdomain: :api), photographer: false }

      it "should return only photographers" do
        subject.each { |result| result['photographer'].should be_false }
      end
    end
  end

  describe "GET /staff/:id" do
    before { get api_staff_url(staff, subdomain: :api) }
    let!(:staff) { FactoryGirl.create :staff }

    it { response.status.should == Rack::Utils.status_code(:ok) }

    it "should have staff attributes" do
      attrs = ActiveSupport::JSON.decode(staff.to_json)
      should include(attrs)
    end

    it "should match Camayak spec" do
      should include(
        'affiliation' => staff.affiliation,
        'biography' => staff.biography,
        'columnist' => staff.columnist,
        'photographer' => staff.photographer?,
        'name' => staff.name,
        'tagline' => staff.tagline,
        'twitter' => staff.twitter,
        'slug' => staff.slug,
      )
    end
  end

  describe "POST /staff" do
    let(:new_staff_attrs) { FactoryGirl.attributes_for :staff }


    it "should require authentication" do
      expect{ post api_staff_index_url(subdomain: :api), new_staff_attrs }.
        to require_authorization
    end

    describe "when staff is valid" do
      before do
        post api_staff_index_url(subdomain: :api), new_staff_attrs,
          'HTTP_AUTHORIZATION' => http_auth(@user)
      end

      it { response.status.should == Rack::Utils.status_code(:created) }

      it "should have the same fields as the original" do
        should include(new_staff_attrs.stringify_keys)
      end

      it "should have an integer id" do
        subject['id'].should be_a_kind_of(Integer)
      end

      it { should include('updated_at', 'created_at') }
      it { Staff.should have(1).record }

      it "should set correct location header" do
        response.location.should ==
          api_staff_url(subject['slug'], subdomain: :api)
      end
    end

    describe "when staff is invalid" do
      before do
        new_staff_attrs.delete(:name)
        post api_staff_index_url(subdomain: :api), new_staff_attrs,
          'HTTP_AUTHORIZATION' => http_auth(@user)
      end

      it do
        response.status.should == Rack::Utils.status_code(:unprocessable_entity)
      end

      it "should respond with validation errors" do
        should include('name')
      end
    end
  end

  describe "PUT /staff/:id" do
    let(:staff_attrs) { FactoryGirl.attributes_for :staff }
    let!(:staff) { FactoryGirl.create :staff, staff_attrs }

    it "should require authentication" do
      expect{ put api_staff_url(staff, subdomain: :api) }.
        to require_authorization
    end

    describe "when update data is valid" do
      let(:updated_attrs) { { name: 'Pokefan Harold' } }

      before do
        put api_staff_url(staff, subdomain: :api), updated_attrs,
          'HTTP_AUTHORIZATION' => http_auth(@user)
      end

      it { response.status.should == Rack::Utils.status_code(:no_content) }

      it "should have updated attributes" do
        staff.reload.name.should == updated_attrs[:name]
      end

      it "should not create or destroy any records" do
        Staff.should have(1).record
      end
    end

    describe "update staff with invalid data" do
      let(:invalid_attrs) { { name: '' } }

      before do
        put api_staff_url(staff, subdomain: :api), invalid_attrs,
          'HTTP_AUTHORIZATION' => http_auth(@user)
      end

      it do
        response.status.should == Rack::Utils.status_code(:unprocessable_entity)
      end

      it "should respond with validation errors" do
        should include('name')
      end
    end
  end

  describe "DELETE /staff/:id" do
    let!(:staff) { FactoryGirl.create :staff }

    it "should require authentication" do
      expect{ delete api_staff_url(staff, subdomain: :api) }.
        to require_authorization
    end

    before do
      delete api_staff_url(staff, subdomain: :api), nil,
        'HTTP_AUTHORIZATION' => http_auth(@user)
    end

    it { response.status.should == Rack::Utils.status_code(:no_content) }

    it "should remove the staff record" do
      Staff.should have(:no).records
    end
  end
end
