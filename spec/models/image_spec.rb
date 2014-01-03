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
  let(:image) { FactoryGirl.create(:image) }
  subject { image }

  it { should have_many(:articles) }
  it { should have_many(:pages) }
  it { should have_many(:staff).with_foreign_key(:headshot_id) }
  it { should belong_to(:photographer).class_name('Staff') }
  it { should have_attached_file(:original) }
  it { should validate_attachment_presence(:original) }

  describe "#date" do
    it { should validate_presence_of(:date) }

    it "should set default date to today's date" do
      subject.date.should == Date.today
    end
  end

  describe "Styles" do
    it "should be set as a constant" do
      Image.const_defined?(:Styles).should be_true
    end

    it "should have version information as values" do
      Image::Styles.each do |type, info|
        info.should include('width', 'height', 'sizes')
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

  describe "#articles" do
    let(:article) { FactoryGirl.create(:article, image_id: subject.id) }

    it "should remove image from articles when destroyed" do
      subject.destroy
      article.image.should be_nil
    end
  end

  describe "#reprocess_style!" do
    before do
      image.original.stub(:reprocess!)
      image.reprocess_style!('vertical')
    end

    it "should reprocess all styles for a type" do
      image.original.should
        have_received(:reprocess!).with('vertical_243x', 'vertical_183x')
    end
  end

  describe "#crop!" do
    before do
      image.original.stub(:reprocess!)
      image.crop!('vertical', 1, 2, 3, 4)
    end

    it "should assign crop instance variables" do
      image.crop_style.should == 'vertical'
      image.crop_x.should == 1
      image.crop_y.should == 2
      image.crop_w.should == 3
      image.crop_h.should == 4
    end

    it "should reprocess all styles for a type" do
      image.original.should
        have_received(:reprocess!).with('vertical_243x', 'vertical_183x')
    end
  end

end
