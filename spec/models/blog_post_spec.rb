require 'spec_helper'


describe Blog::Post do

  subject { FactoryGirl.build(:blog_post) }

  it { should belong_to(:author).class_name("Staff") }
  it { should validate_presence_of(:author) }

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

  describe "#blog" do
    before { subject.blog = 'kanto_news' }

    it { should validate_presence_of(:blog) }
    its(:blog) { should be_a_kind_of(Blog) }
  end

end