require 'spec_helper'


describe Blog::Post do
  let(:blog_post) { FactoryGirl.build(:blog_post) }
  subject { blog_post }

  it { Blog::Post.should be_searchable }
  it { should be_a_kind_of(Post) }

  describe "::tagged_with" do
    let(:blog_posts) do
      [
       FactoryGirl.create(:blog_post, tag_list: 'squirtle,charmander'),
       FactoryGirl.create(:blog_post, tag_list: 'Squirtle,Charmander'),
       FactoryGirl.create(:blog_post, tag_list: 'bulbasaur,charmander'),
      ]
    end

    subject { Blog::Post.tagged_with('SQUIRTLE') }

    it "should return case insensitive matches" do
      should include(blog_posts[0])
      should include(blog_posts[1])
    end

    it "should exclude posts without the tag" do
      should_not include(blog_posts[2])
    end
  end

  describe "#blog=" do
    before { subject.blog = Blog.find('kantonews') }
    its(:blog) { should == Blog.find('kantonews') }
    its(:blog_id) { should == 'kantonews' }
    its(:section) { should == Taxonomy.new(:blogs, ['Kanto News']) }
  end
end
