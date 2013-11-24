require 'spec_helper'


describe ArticleHelper do
  let(:article) { FactoryGirl.create(:article) }


  describe "#byline" do
    before { article.authors = [Staff.create!(name: 'Hiker Mikael')] }

    it "should be the conjunction of the author names sorted by last name" do
      article.authors += [Staff.create!(name: 'Youngster Juan'),
                          Staff.create!(name: 'Swimmer Richard')]
      helper.byline(article)
        .should == "Youngster Juan, Hiker Mikael, and Swimmer Richard"
    end

    it "should use anchor tags for names if link option is used" do
      helper.byline(article, link: true)
        .should == '<a href="/staff/hiker-mikael/articles">Hiker Mikael</a>'
    end

    it "should be html safe if link option is used" do
      helper.byline(article, link: true).should be_html_safe
    end
  end

  describe "#mailto_article" do
    subject { helper.mailto_article(article) }

    it { should match(/^mailto:\?subject=.*&body=.*$/) }
    it "should escape characters in the body" do
      should match(/body=\S+$/)
    end
  end
end
