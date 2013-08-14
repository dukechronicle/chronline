require 'spec_helper'

describe Search do
  describe "#initialize" do
    context "when initialized with model parameter" do
      it "should extend model specific search module" do
        search = Search.new(model: Article)
        search.should be_a(Article::Search)
        search.should respond_to(:section)
      end

      it "should accept model class name as string" do
        search = Search.new(model: 'Article')
        search.should be_a(Article::Search)
        search.model.should == Article
      end
    end

    it "should use default values for options" do
      today = DateTime.new(1998, 9, 30)
      DateTime.stub(:now).and_return(today)
      search = Search.new

      search.page.should == 1
      search.per_page.should == 25
      search.sort.should == :score
      search.order.should == :desc
      search.highlight.should == false
      search.end_date.should == today
    end

    it "should accept attributes" do
      search = Search.new(page: 2)
      search.page.should == 2
    end
  end

  describe "#results" do
    let(:search) { Search.new(query: 'jhoto') }
    subject { search.results }

    context "when query is blank" do
      let(:search) { Search.new(query: '') }
      it { should be_nil }
    end

    it "should be paginatable" do
      subject.total_pages.should be_an(Integer)
    end

    it "should cache solr request" do
      search.results
      Sunspot.stub(:search)  # Start spying on search method
      search.results
      Sunspot.should_not have_received(:search)
    end

    context "when highlight option is on" do
      context "when matched query is in title" do
        before { FactoryGirl.create(:article, title: 'Ash goes to Jhoto') }
        it "should set wrap highlighted elements of title with <mark> tags"
      end

      context "when matched query is in body" do
        before { FactoryGirl.create(:article, body: 'Ash goes to Jhoto') }
        it "should set wrap highlighted elements of body with <mark> tags"
      end
    end
  end
end
