require 'spec_helper'

describe Api::StaffController do
  let(:success) { 200 }
  let(:created) { 201 }
  let(:bad_request) { 400 }
  let(:no_response) { 204 }

  describe "GET /staff/*" do
    let!(:orig_staff) { FactoryGirl.create_list :staff, 30 }
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }

    describe "list staff" do
      before { get api_staff_index_url(subdomain: :api, page: 1) }

      its(:status) { should == success }
      it { res.should have(25).staff }
    end

    describe "get a staff" do
      before { get api_staff_url(subdomain: :api, id: orig_staff[0].id) }

      its(:status) { should == success }
      it "should have staff attributes" do
        attrs = json_attributes orig_staff[0]
        res.should include(attrs)
      end
    end
  end

  describe "POST /staff/" do
    let(:res) { ActiveSupport::JSON.decode(response.body).symbolize_keys }
    subject { response }
    describe "create valid staff" do
      let(:new_staff_attrs) { FactoryGirl.attributes_for :staff }
      before { post api_staff_index_url(subdomain: :api), staff: new_staff_attrs }

      its(:status) { should == created }
      it "should have the same fields as the original" do
        res.should include(new_staff_attrs)
      end
      it "should have an integer id" do
        res[:id].should be_a_kind_of(Integer)
      end
      it "should include updated_at and created_at" do
        res.should include(:updated_at, :created_at)
      end
      it { change(Staff, :count).by(1) }
    end

    describe "create invalid staff" do
      before { post api_staff_index_url(subdomain: :api), staff: {} }
      its(:status) { should == bad_request }
    end
  end

  describe "PUT /staff/*" do
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }
    let!(:staff_attrs) { FactoryGirl.attributes_for :staff }
    let!(:staff) { FactoryGirl.create :staff, staff_attrs }
    describe "update staff with valid data" do
      let(:updated_attrs) do
        new_staff_attrs = staff_attrs.clone
        new_staff_attrs[:name] = 'Ash Ketchup'
        new_staff_attrs
      end
      before { put api_staff_url(subdomain: :api, id: staff.id, staff: updated_attrs) }

      its(:status) { should == no_response }
      it "should have a changed name" do
        staff.reload
        staff.name.should eq(updated_attrs[:name])
      end
    end

    describe "update staff with invalid data" do
      let(:invalid_attrs) { {name: '' } }
      before { put api_staff_url subdomain: :api, id: staff.id, staff: invalid_attrs }
      its(:status) { should == bad_request }
    end
  end
end

def json_attributes(model)
  attrs = model.attributes
  # Timestamps are in different format for JSON
  attrs.each do |key, value|
    if value.respond_to?(:iso8601)
      attrs[key] = value.iso8601
    end
  end
  attrs
end
