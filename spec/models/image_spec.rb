# == Schema Information
#
# Table name: images
#
#  id                    :integer          not null, primary key
#  caption               :string(255)
#  location              :string(255)
#  original_file_name    :string(255)
#  original_content_type :string(255)
#  original_file_size    :integer
#  original_updated_at   :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  photographer_id       :integer
#

require 'spec_helper'

describe Image do

  subject { FactoryGirl.create(:image) }

  it "should set default date to today's date" do
    subject.date.should == Date.today
  end

  describe "articles" do
    let(:article) { FactoryGirl.create(:article, image_id: subject.id) }

    it "should remove image from articles when destroyed" do
      subject.destroy
      article.image.should be_nil
    end
  end

  describe "Styles" do
    it "should be set as a constant" do
      Image.const_defined?(:Styles).should be_true
    end

    it "should have version information as values" do
      Image::Styles.each do |k, v|
        v.should include('width', 'height', 'description')
      end
    end
  end

  describe "::styles" do
    it "should be a hash of version dimensions" do
      Image.styles.each do |version, dimensions|
        version.should be_a(Symbol)
        dimensions.should match(/\d+x\d+#/)
      end
    end
  end

  describe "#to_jq_upload" do
    it "should be an array with one hash" do
      subject.to_jq_upload.should be_an(Array)
      subject.to_jq_upload.should have(1).item
    end

    it "should have required jQuery upload properties" do
      hash = subject.to_jq_upload.first
      hash.should have_key(:name)
      hash.should have_key(:size)
      hash.should have_key(:url)
      hash.should have_key(:thumbnail_url)
      hash.should have_key(:delete_url)
      hash.should have_key(:delete_type)
    end
  end

end
