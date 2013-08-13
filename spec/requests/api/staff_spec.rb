require 'spec_helper'

describe "/staff/*" do
  before(:all) { @user = FactoryGirl.create(:user) }
  after(:all) { @user.destroy }
  subject { ActiveSupport::JSON.decode(response.body) }

  describe "GET /staff" do
    let!(:staff) { FactoryGirl.create_list :staff, 5 }

    context "when page 1 is fetched" do
      before { get api_staff_index_url(subdomain: :api, page: 1, limit: 3) }

      it { response.status.should == Rack::Utils.status_code(:ok) }
      it { should have(3).staff }
    end

    context "when page 2 is fetched" do
      before { get api_staff_index_url(subdomain: :api, page: 2, limit: 3) }

      it { response.status.should == Rack::Utils.status_code(:ok) }
      it { should have(2).staff }
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

    describe "when user is not authenticated" do
      before do
        post api_staff_index_url(subdomain: :api), new_staff_attrs
      end

      it { response.status.should == Rack::Utils.status_code(:unauthorized) }
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

    describe "when user is not authenticated" do
      before { put api_staff_url(staff, subdomain: :api) }
      it { response.status.should == Rack::Utils.status_code(:unauthorized) }
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

    describe "when user is not authenticated" do
      before { delete api_staff_url(staff, subdomain: :api) }
      it { response.status.should == Rack::Utils.status_code(:unauthorized) }
    end

    describe "when user is authenticated" do
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
end
