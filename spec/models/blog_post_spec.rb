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

  describe "#series" do
    let!(:blog_series) { FactoryGirl.create(:blog_series) }
    subject { blog_post.series }

    context "when not tagged with a series" do
      it { should be_nil }
    end

    context "when tagged with a series for another blog" do
      before do
        blog_post.update_attributes!(
          tag_list: ["Route 14"],
          blog: Blog.find('kantonews')
        )
      end

      it { should be_nil }
    end

    context "when tagged with a series for the same blog" do
      before { blog_post.update_attributes!(tag_list: ["Route 14"]) }
      it "should be assigned to the associated series" do
        should == blog_series
      end
    end
  end
end
