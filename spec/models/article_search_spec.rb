require 'spec_helper'

describe Article::Search do
  describe "#results" do
    it { should ensure_length_of(:query).is_at_least 2 }

    it "should always be paginatable" do
      Article::Search.new.results.total_pages.should be_a(Integer)
      Article::Search.new(query: "lala" ).results.total_pages.should be_a(Integer)
    end

    pending "should highlight the query in each results' title" do

    end

    pending "should not change the title when highlighted" do

    end

    pending "should higlight the query in each results' body" do

    end

    pending "should return the full title" do

    end

    pending "should return a relevant section of the body" do

    end

  end
end
