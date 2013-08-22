require 'spec_helper'
include ArticleHelper

describe Api::ArticlesController do
  before(:all) { @user = FactoryGirl.create(:user) }
  after(:all) { @user.destroy }

  shared_examples_for "an article response" do
    it "should have article properties" do
      attrs = ActiveSupport::JSON.decode(article.to_json)
      should include(attrs)
    end

    it "should match Camayak spec" do
      should include(
        'id' => article.id,
        'published_url' => site_article_url(article, subdomain: :www),
        'author_ids' => article.author_ids,
        'slug' => article.slug,
        'title' => article.title,
        'subtitle' => article.subtitle,
        'teaser' => article.teaser,
        'body' => article.body,
        'created_at' => article.created_at.iso8601,
        'updated_at' => article.updated_at.iso8601,
        'section' => article.section.to_a,
        'published_at' => (article.published_at.iso8601 if article.published_at),
        'image_id' => article.image_id,
      )
    end

    it "should not include previous_id" do
      should_not include(:previous_id)
    end

    its(['slug']) { should match(%r[(\d{4}/\d{2}/\d{2}/)?[^/]+]) }
  end
  describe "GET /section/*" do
    let!(:original_articles) do
      [
       FactoryGirl.create(:article, section: '/news/'),
       FactoryGirl.create(:article, section: '/news/', published_at: nil),
      ]
    end
    let(:articles) { ActiveSupport::JSON.decode(response.body) }
    subject { response }

    context "incorrect section" do
      before { get api_article_section_url(subdomain: :api, section: 'sports') }

      its(:status) { should == Rack::Utils.status_code(:ok) }
      it { articles.should be_empty }
    end

    describe "correct section" do
      let(:article) { original_articles[0] }

      before { get api_article_section_url(subdomain: :api, section: 'news') }

      its(:status) { should == Rack::Utils.status_code(:ok) }
      it { articles.should have(1).articles }

      it "should not include unpublished articles" do
        articles.first['published_at'].should be_present
      end

      it "should include the authors" do
        article.authors.each_with_index do |author, i|
          attrs = json_attributes(author)
          articles.first['authors'][i].should include(attrs)
        end
      end

      it_should_behave_like "an article response" do
        subject { articles.first }
      end
    end
  end

  describe "GET /articles" do
    let!(:original_articles) do
      [
       FactoryGirl.create(:article, section: '/news/'),
       FactoryGirl.create(:article, section: '/news/', published_at: nil),
       FactoryGirl.create(:article, section: '/sports/'),
       FactoryGirl.create(:article, section: '/sports/'),
      ]
    end
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }

    context "when filtering by section" do
      before { get api_articles_url(subdomain: :api, section: 'news') }

      its(:status) { should == Rack::Utils.status_code(:ok) }
      it { res.should have(1).articles }

      it_should_behave_like "an article response" do
        subject { res.first }
        let(:article) { original_articles[0] }
      end
    end

    context "when page 1 is fetched" do
      before { get api_articles_url(subdomain: :api, page: 1, limit: 2) }

      its(:status) { should == Rack::Utils.status_code(:ok) }
      it { res.should have(2).articles }

      it_should_behave_like "an article response" do
        subject { res.first }
        let(:article) { Article.find(res.first['id']) }
      end
    end

    context "when page 2 is fetched" do
      before { get api_articles_url(subdomain: :api, page: 2, limit: 2) }

      its(:status) { should == Rack::Utils.status_code(:ok) }
      it { res.should have(1).articles }

      it_should_behave_like "an article response" do
        subject { res.first }
        let(:article) { Article.find(res.first['id']) }
      end
    end
  end


  describe "GET /articles/:id" do
    let(:article) { FactoryGirl.create :article }
    before { get api_article_url(subdomain: :api, id: article.id) }
    subject { response }

    its(:status) { should == Rack::Utils.status_code(:ok) }

    it_should_behave_like "an article response" do
      subject { ActiveSupport::JSON.decode(response.body) }
    end
  end

  describe "POST /articles/" do
    let(:new_article_data) do
      convert_objs_to_ids(
        FactoryGirl.attributes_for(:article), :authors, :author_ids)
    end
    subject { response }

    it "should require authentication" do
      expect{ post api_articles_url(subdomain: :api), new_article_data }.
        to require_authorization
    end

    context "when properly authenticated" do
      before do
        post api_articles_url(subdomain: :api), new_article_data,
          { 'HTTP_AUTHORIZATION' => http_auth(@user) }
      end

      its(:status) { should == Rack::Utils.status_code(:created) }

      it_should_behave_like "an article response" do
        subject { ActiveSupport::JSON.decode(response.body) }
        let(:article) { Article.find(subject['id']) }
      end
    end
  end

  describe "POST /articles/:id/unpublish" do
    let(:article) { FactoryGirl.create :article }
    subject { response }

    it "should require authentication" do
      expect{ post unpublish_api_article_url(article.id, subdomain: :api) }.
        to require_authorization
    end

    context "when properly authenticated" do
      before do
        post unpublish_api_article_url(article.id, subdomain: :api), nil,
            { 'HTTP_AUTHORIZATION' => http_auth(@user) }
        article.reload
      end

      it "should be unpublished" do
        article.published?.should be_false
      end
      its(:status) { should == Rack::Utils.status_code(:ok) }

      it_should_behave_like "an article response" do
        subject { ActiveSupport::JSON.decode(response.body) }
      end
    end
  end

  describe "PUT /articles/*" do
    let(:original_article) { FactoryGirl.build :article }
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }

    describe "update article" do
      let(:article_attrs) { FactoryGirl.attributes_for :article }
      let(:article) { FactoryGirl.create :article, article_attrs }
      let(:valid_attrs) { {title: "Magikarp: Underrated?" } }

      it "should require authentication" do
        expect{ put api_article_url(article.id, subdomain: :api), valid_attrs }.
          to require_authorization
      end

      describe "with valid data" do
        before do
          put api_article_url(article.id, subdomain: :api), valid_attrs,
            { 'HTTP_AUTHORIZATION' => http_auth(@user) }
        end
        its(:status) { should == Rack::Utils.status_code(:no_content) }
        it "should have a changed title" do
          article.reload.title.should == valid_attrs[:title]
        end
      end

      describe "with invalid data" do
        let(:invalid_attrs) { {title: "" } }
        before do
          put api_article_url(article.id, subdomain: :api), invalid_attrs,
            { 'HTTP_AUTHORIZATION' => http_auth(@user) }
        end
        it { response.status.should == Rack::Utils.status_code(:unproccessable_entity) }
        it "should respond with validation errors" do
          res.should include('title')
        end
      end
    end
  end

  describe "DELETE /article/*" do
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }
    let!(:article) { FactoryGirl.create :article }
    it "should require authentication" do
      expect{ delete api_article_url(article.id, subdomain: :api) }.
        to require_authorization
    end

    context "when properly authenticated" do
      before do
        delete api_article_url(article.id, subdomain: :api), nil,
          { 'HTTP_AUTHORIZATION' => http_auth(@user) }
      end

      it { response.status.should == Rack::Utils.status_code(:no_content) }

      it "should remove the article" do
        Article.should have(:no).records
      end
    end
  end
end

def convert_objs_to_ids(hash, key, new_key)
  hash[new_key] = hash.delete(key).map { |obj| obj.id }
  hash
end
