require 'spec_helper'

describe "Articles API" do

  describe "GET /section/*" do
    before { @article = FactoryGirl.create(:article_with_authors) }

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
        attrs = json_attributes(@article)
        attrs['section'] = @article.section.to_a
        articles.first.should include(attrs)
      end

      it "should have the authors" do
        @article.authors.each_with_index do |author, i|
          attrs = json_attributes(author)
          attrs.delete('type')
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
