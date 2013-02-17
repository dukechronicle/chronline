require 'spec_helper'


describe ImageHelper do
  let(:image) { FactoryGirl.create(:image) }

  describe "#photo_credit" do
    subject { helper.photo_credit(image) }

    context "image has a photographer" do
      before { image.photographer = Staff.create(name: 'Sabrina') }

      it "should be the photographer's name with the correct attribution" do
        should == "Sabrina / Gym Leader"
      end

      it "should be the just photographer's name if no attribution" do
        image.attribution = nil
        should == "Sabrina"
      end

      context "link option used" do
        subject { helper.photo_credit(image, link: true) }

        it "should use anchor tags" do
          should == '<a href="/staff/sabrina/images">Sabrina</a> / Gym Leader'
        end

        it { should be_html_safe }
      end
    end

    context "image only has a credit" do
      before do
        image.photographer = nil
        image.credit = "Photo taken by Gary"
      end

      it { should == image.credit }
    end
  end
end
