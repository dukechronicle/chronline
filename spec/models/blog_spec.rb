require 'spec_helper'


describe Blog do
  it "should not be directly instantiable" do
    expect { Blog.new }.to raise_error
  end

  let(:blog_id) { 'pokedex' }
  let(:blog) { Blog.find(blog_id) }
  subject { blog }

  # Required to comply with ActiveModel interface
  it { should be_persisted }

  describe "::find" do
    its(:id) { should == blog_id }
    its(:name) { should == 'Pokedex' }
    its(:description) { should == "Gotta catch em all" }
  end

  describe "#==" do
    it { should_not == double("NotABlog", id: blog_id) }
    it { should_not == Blog.find('kantonews') }
    it { should == Blog.find(blog_id) }
  end

  describe "#twitter_widgets" do
    it "should default to an empty array" do
      subject.twitter_widgets.should == []
    end
  end

  its(:to_param) { should == blog_id }
  its(:taxonomy) { should == Taxonomy.new(:blogs, ['Pokedex']) }

  describe "::all" do
    subject { Blog.all }

    it { should have(2).blogs }
    it { should include(blog) }
  end

  describe "::each" do
    it "should yield to each blog" do
      expect { |b| Blog.each(&b) }.to yield_successive_args(*Blog.all)
    end
  end

  describe "::find_by_taxonomy" do
    subject { Blog.find_by_taxonomy(taxonomy) }

    context "when not a blog taxonomy" do
      let(:taxonomy) { Taxonomy.new(:sections, ['News']) }
      it { should be_nil }
    end

    context "when taxonomy is valid" do
      let(:taxonomy) { Taxonomy.new(:blogs, ['Pokedex']) }
      it { should == blog }
    end
  end

  describe "#posts" do
    before do
       FactoryGirl.create(:blog_post, blog: Blog.find('kantonews'))
       FactoryGirl.create(:blog_post, blog: Blog.find('pokedex'))
    end

    subject { blog.posts }

    it { should have(1).item }
    it "should only be posts from the correct blog" do
      subject.each do |blog_post|
        blog_post.blog.should == blog
      end
    end
  end
end
