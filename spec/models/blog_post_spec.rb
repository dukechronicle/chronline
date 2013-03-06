require 'spec_helper'


describe Blog::Post do

  subject { FactoryGirl.build(:blog_post) }

  describe "#blog" do
    before { subject.blog = Blog.find('playground') }

    its(:blog) { should be_a_kind_of(Blog) }
  end

end
