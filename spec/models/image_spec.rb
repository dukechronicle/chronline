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

end
