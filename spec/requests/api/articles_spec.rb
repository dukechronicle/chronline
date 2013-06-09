require 'spec_helper'

describe Api::ArticlesController do

  describe "GET /section/*" do
    let!(:original_articles) do
      [
       FactoryGirl.create(:article, section: '/news/'),
       FactoryGirl.create(:article, section: '/news/', published_at: nil),
      ]
    end
    let(:success) { 200 }
    let(:articles) { ActiveSupport::JSON.decode(response.body) }
    subject { response }

    context "incorrect section" do
      before { get api_article_section_url(subdomain: :api, section: 'sports') }

      its(:status) { should == success }
      it { articles.should be_empty }
    end

    describe "correct section" do
      let(:article) { original_articles[0] }

      before { get api_article_section_url(subdomain: :api, section: 'news') }

      its(:status) { should == success }
      it { articles.should have(1).articles }

      it "should not include unpublished articles" do
        articles.first['published_at'].should be_present
      end

      it "should have article properties" do
        attrs = json_attributes(article)
        attrs['section'] = article.section.to_a
        articles.first.should include(attrs)
      end

      it "should include the authors" do
        article.authors.each_with_index do |author, i|
          attrs = json_attributes(author)
          articles.first['authors'][i].should include(attrs)
        end
      end
    end
  end
end

def json_attributes(model)
  attrs = model.attributes
  # Timestamps are in different format for JSON
  attrs.each do |key, value|
    if value.respond_to?(:iso8601)
      attrs[key] = value.iso8601
    end
  end
  attrs
end
