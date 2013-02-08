require 'spec_helper'


describe ArticleHelper do
  let(:article) { FactoryGirl.create(:article) }


  describe "#byline" do
    before { article.authors = [Staff.create!(name: 'Hiker Mikael')] }

    it "should be the conjunction of the author names" do
      article.authors += [Staff.create!(name: 'Youngster Juan'),
                          Staff.create!(name: 'Swimmer Richard')]
      helper.byline(article)
        .should == "Hiker Mikael, Youngster Juan, and Swimmer Richard"
    end

    it "should use anchor tags for names if link option is used" do
      helper.byline(article, link: true)
        .should == '<a href="/staff/hiker-mikael">Hiker Mikael</a>'
    end

    it "should be html safe if link option is used" do
      helper.byline(article, link: true).should be_html_safe
    end
  end

  describe "#display_date" do
    before { article.created_at = Date.new(2013, 1, 1) }

    it "should display creation date in specified format" do
      helper.display_date(article, '%Y').should == '2013'
    end

    it "should default to readable date format" do
      helper.display_date(article).should == 'January 1, 2013'
    end
  end

  describe "#disqus_options" do
    subject { ActiveSupport::JSON.decode(helper.disqus_options(article)) }

    it "should be valid JSON" do
      lambda { subject }.should_not raise_error(MultiJson::DecodeError)
    end

    it "should have disqus options fields" do
      should have_key('production')
      should have_key('shortname')
      should have_key('identifier')
      should have_key('title')
      should have_key('url')
    end
  end

end
