require 'spec_helper'


describe Blog::Post do

  subject { FactoryGirl.build(:blog_post) }

  it { should belong_to(:author).class_name("Staff") }
  it { should validate_presence_of(:author) }

  describe "#blog" do
    before { subject.blog = 'playground' }

    it { should validate_presence_of(:blog) }
    its(:blog) { should be_a_kind_of(Blog) }
  end

end
