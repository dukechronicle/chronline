# == Schema Information
#
# Table name: staff
#
#  id          :integer          not null, primary key
#  affiliation :string(255)
#  biography   :text
#  columnist   :boolean
#  name        :string(255)
#  tagline     :string(255)
#  twitter     :string(255)
#  type        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string(255)
#

require 'spec_helper'

describe Staff do

  it { should have_many(:images).with_foreign_key(:photographer_id) }
  it { should have_and_belong_to_many(:articles) }
  it { should have_and_belong_to_many(:blog_posts) }
  it { should belong_to(:headshot).class_name("Image") }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }


  describe Staff do
    let!(:staff) do
      [
       FactoryGirl.create(:staff, name: 'Joe Smith'),
       FactoryGirl.create(:staff, name: 'John Smith'),
       FactoryGirl.create(:staff, name: 'Will Smith'),
      ]
    end

    describe "::search" do
      it "should return staff with matching names" do
        Staff.search('Jo').should have(2).members
      end

      it "should return all when given nil" do
        Staff.search(nil).should have(3).members
      end
    end
  end

  describe "#author?" do
    subject { FactoryGirl.build(:staff) }

    context "when staff has no articles" do
      it { should_not be_author }
    end

    context "when staff has an article" do
      before { subject.articles << FactoryGirl.build(:article) }
      it { should be_author }
    end
  end

  describe "#blogger?" do
    subject { FactoryGirl.build(:staff) }

    context "when staff has no articles" do
      it { should_not be_blogger }
    end

    context "when staff has a blog_post" do
      before { subject.blog_posts << FactoryGirl.build(:blog_post) }
      it { should be_blogger }
    end
  end

  describe "#last_name" do
    context "when name has two words" do
      subject { FactoryGirl.build(:staff, name: 'Ash Ketchum') }
      its(:last_name) { should == 'Ketchum' }
    end

    context "when name has more than two words" do
      subject { FactoryGirl.build(:staff, name: 'Champion Ash Ketchum') }
      its(:last_name) { should == 'Ketchum' }
    end
  end

  describe "#photographer?" do
    subject { FactoryGirl.build(:staff) }

    context "when staff has no images" do
      it { should_not be_photographer }
    end

    context "when staff has an image" do
      before { subject.images << FactoryGirl.build(:image) }
      it { should be_photographer }
    end
  end
end
