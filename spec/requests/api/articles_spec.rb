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

  describe "GET /articles/*" do
    let!(:original_articles) do
      [
       FactoryGirl.create(:article, section: '/news/'),
       FactoryGirl.create(:article, section: '/news/', published_at: nil),
       FactoryGirl.create(:article, section: '/sports/'),
      ]
    end
    let(:success) { 200 }
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }

    describe "list articles" do
      before { get api_articles_url(subdomain: :api, section: 'news') }

      its(:status) { should == success }
      it { res.should have(1).articles }
    end

    describe "get article" do
      let(:article) { original_articles[0] }
      before { get api_article_url(subdomain: :api, id: article.id) }

      its(:status) { should == success }

      it "should have article properties" do
        attrs = json_attributes(article)
        attrs['section'] = article.section.to_a
        res.should include(attrs)
      end
    end
  end

  describe "POST /articles/" do
    let(:success) { 200 }
    let(:created) { 201 }
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }

    describe "create article" do
      let(:new_article_data) do
        convert_objs_to_ids(
          FactoryGirl.attributes_for(:article), :authors, :author_ids)
      end
      before { post api_articles_url(subdomain: :api), article: new_article_data}

      its(:status) { should == created }
      it "should include the data posted" do
        puts "res"
        res.sort.each { |k, v| puts "#{k} #{v}" }
        puts "new_article_data"
        new_article_data.sort.each { |k, v| puts "#{k} #{v}" }
        res.should include(new_article_data)
      end
    end
  end

  describe "PUT /articles/*" do
    let(:original_article) { FactoryGirl.build :article }
    let(:no_response) { 204 }
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }

    describe "update article" do
      let(:article_attrs) { FactoryGirl.attributes_for :article }
      let(:article) { FactoryGirl.create :article, article_attrs }

      describe "update article with valid data" do
        let(:updated_attrs) do
          new_article_attrs = article_attrs.clone
          new_article_attrs[:body] = "**Agumon** wrecks everyone. The End."
          new_article_attrs = convert_objs_to_ids(
            :new_article_attrs, authors, :author_ids)
          new_article_attrs
        end
        before { put api_article_url(subdomain: :api, id: article.id, article: updated_attrs) }
        its(:status) { should == no_response }
        it "should have a changed body" do
          article.reload
          article.body.should == updated_attrs[:body]
        end
      end
    end
  end

  describe "DELETE /article/*" do
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }
    let!(:article) { FactoryGirl.create :article }
    it { change(Article, :count).by(1) }
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

def convert_objs_to_ids(hash, key, new_key)
  hash[new_key] = hash.delete(key).map { |obj| obj.id }
  hash
end
