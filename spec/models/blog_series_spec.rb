require 'spec_helper'


describe Blog::Series do
  let(:blog_series) { FactoryGirl.build(:blog_series) }
  let(:blog_post) { FactoryGirl.build(:blog_post) }
  subject { blog_series }

  it { should validate_presence_of(:tag) }
  it { should validate_presence_of(:image) }

  its(:name) { should == "Route 14" }
end
