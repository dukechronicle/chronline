require 'spec_helper'

describe "/staff/*" do
  before(:all) { @user = FactoryGirl.create(:user) }
  after(:all) { @user.destroy }
  subject { ActiveSupport::JSON.decode(response.body) }

  describe "GET /staff" do
    let!(:orig_staff) { FactoryGirl.create_list :staff, 30 }

    context "when page 1 is fetched" do
      before { get api_staff_index_url(subdomain: :api, page: 1) }

      it { response.status.should == Rack::Utils.status_code(:ok) }
      it { should have(25).staff }
    end

    context "when page 2 is fetched" do
      before { get api_staff_index_url(subdomain: :api, page: 2) }

      it { response.status.should == Rack::Utils.status_code(:ok) }
      it { should have(5).staff }
    end
  end

  describe "GET /staff/:id" do
    before { get api_staff_url(orig_staff, subdomain: :api) }
    let!(:orig_staff) { FactoryGirl.create :staff }

    it { response.status.should == Rack::Utils.status_code(:ok) }

    it "should have staff attributes" do
      attrs = ActiveSupport::JSON.decode(orig_staff.to_json)
      should include(attrs)
    end
  end

  describe "POST /staff" do
    let(:new_staff_attrs) { FactoryGirl.attributes_for :staff }

    describe "when user is not authenticated" do
      before do
        post api_staff_index_url(subdomain: :api), staff: new_staff_attrs
      end

      it { response.status.should == Rack::Utils.status_code(:unauthorized) }
    end

    describe "when staff is valid" do
      before do
        post api_staff_index_url(subdomain: :api), { staff: new_staff_attrs },
          { 'HTTP_AUTHORIZATION' => http_auth(@user) }
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
    end

    describe "when staff is invalid" do
      before do
        new_staff_attrs.delete(:name)
        post api_staff_index_url(subdomain: :api), { staff: new_staff_attrs },
          { 'HTTP_AUTHORIZATION' => http_auth(@user) }
      end

      it { response.status.should == Rack::Utils.status_code(:bad_request) }
      it "should respond with validation errors" do
        should include('name')
      end
    end
  end

  describe "PUT /staff/:id" do
    let(:staff_attrs) { FactoryGirl.attributes_for :staff }
    let!(:staff) { FactoryGirl.create :staff, staff_attrs }

    describe "when user is not authenticated" do
      before { delete api_staff_url(staff, subdomain: :api) }
      it { response.status.should == Rack::Utils.status_code(:unauthorized) }
    end

    describe "when update data is valid" do
      let(:updated_attrs) { { name: 'Pokefan Harold' } }

      before do
        put api_staff_url(subdomain: :api, id: staff.id),
          { staff: updated_attrs }, { 'HTTP_AUTHORIZATION' => http_auth(@user) }
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
        put api_staff_url(subdomain: :api, id: staff.id),
          { staff: invalid_attrs }, { 'HTTP_AUTHORIZATION' => http_auth(@user) }

        it { response.status.should == Rack::Utils.status_code(:bad_request) }
        it "should respond with validation errors" do
          should include('name')
        end
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
          { 'HTTP_AUTHORIZATION' => http_auth(@user) }
      end

      it { response.status.should == Rack::Utils.status_code(:no_content) }

      it "should remove the staff record" do
        Staff.should have(:no).records
      end
    end
  end
end
