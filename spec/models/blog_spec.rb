require 'spec_helper'


describe Blog do
  it "should not be directly instantiable" do
    ->{ Blog.new }.should raise_error
  end

  let(:blog) { Blog.find('pokedex') }
  subject { blog }

  # Required to comply with ActiveModel interface
  it { should be_persisted }

  describe "::find" do
    its(:id) { should == 'pokedex' }
    its(:name) { should == 'The Pokedex' }
    its(:description) { should == "Gotta catch em all" }
  end

  describe "#==" do
    it { should_not == double("NotABlog", id: 'pokedex') }
    it { should_not == Blog.send(:new, id: 'Johto') }
    it { should == Blog.send(:new, id: 'pokedex') }
  end

  describe "#to_param" do
    it { subject.to_param.should == 'pokedex' }
  end

  describe "::all" do
    subject { Blog.all }

    it { should have(2).blogs }
    it { should include(blog) }
  end

  describe "::each" do
    it { expect {|b| Blog.each(&b) }.to yield_successive_args(*Blog.all) }
  end

  describe "#posts" do
    let(:tomorrow) { DateTime.now - 1.day }
    before do
      FactoryGirl.create(:blog_post, blog: 'kanto_news', published_at: tomorrow)
      FactoryGirl.create(:blog_post, blog: 'pokedex', published_at: tomorrow)
    end

    its(:posts) { should have(1).item }
  end
end
