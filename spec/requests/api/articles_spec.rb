require 'spec_helper'

describe "Articles API" do

  describe "GET /section/*" do
    before { @article = FactoryGirl.create(:article) }

    let(:success) { 200 }
    let(:articles) { JSON.parse(response.body) }

    describe "incorrect section" do
      before { get api_article_section_url(subdomain: :api, section: 'sports') }

      it { response.status.should be(success) }
      it { articles.should be_empty }
    end

    describe "correct section" do
      before { get api_article_section_url(subdomain: :api, section: 'news') }

      it { response.status.should be(success) }

      it { articles.should have(1).articles }

      it "should have article properties" do
        attrs = @article.attributes
        # Timestamps are in different format for JSON
        attrs.each do |key, value|
          if value.respond_to?(:iso8601)
            attrs[key] = value.iso8601
          end
        end
        attrs['section'] = @article.section.to_a
        articles.first.should include(attrs)
      end
    end
  end
end
