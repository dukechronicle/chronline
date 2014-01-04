require 'spec_helper'

describe Api::ArticlesController do
  before(:all) { @user = FactoryGirl.create(:user) }
  after(:all) { @user.destroy }
  let(:articles) { ActiveSupport::JSON.decode(response.body) }
  subject { articles }

  shared_examples_for "an article response" do
    it "should have article properties" do
      attrs = ActiveSupport::JSON.decode(
        article.to_json(except: [:previous_id, :block_bots]))
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

    it "should not include block_bots" do
      should_not include(:block_bots)
    end

    its(['slug']) { should match(%r[(\d{4}/\d{2}/\d{2}/)?[^/]+]) }
  end

  describe "GET /section/*" do
    let!(:records) do
      [
       FactoryGirl.create(:article, section: '/news/'),
       FactoryGirl.create(:article, section: '/news/', published_at: nil),
      ]
    end

    context "empty section" do
      before { get api_article_section_url(subdomain: :api, section: 'sports') }

      it { response.should have_status_code(:ok) }
      it { should be_empty }
    end

    describe "correct section" do
      let(:article) { records.first }

      before { get api_article_section_url(subdomain: :api, section: 'news') }

      it { response.should have_status_code(:ok) }
      it { should have(1).articles }

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
    let!(:records) do
      [
       FactoryGirl.create(:article, section: '/news/'),
       FactoryGirl.create(:article, section: '/news/', published_at: nil),
       FactoryGirl.create(:article, section: '/sports/'),
       FactoryGirl.create(:article, section: '/sports/'),
      ]
    end

    context "when filtering by section" do
      before { get api_articles_url(subdomain: :api, section: 'news') }

      it { response.should have_status_code(:ok) }
      it { should have(1).articles }

      it_should_behave_like "an article response" do
        subject { articles.first }
        let(:article) { records.first }
      end
    end

    context "when page 1 is fetched" do
      before { get api_articles_url(subdomain: :api, page: 1, limit: 2) }

      it { response.should have_status_code(:ok) }
      it { should have(2).articles }

      it_should_behave_like "an article response" do
        subject { articles.first }
        let(:article) { Article.find(subject['id']) }
      end
    end

    context "when page 2 is fetched" do
      before { get api_articles_url(subdomain: :api, page: 2, limit: 2) }

      it { response.should have_status_code(:ok) }
      it { should have(1).articles }

      it_should_behave_like "an article response" do
        subject { articles.first }
        let(:article) { Article.find(subject['id']) }
      end
    end
  end


  describe "GET /articles/:id" do
    before { get api_article_url(article, subdomain: :api) }
    let!(:article) { FactoryGirl.create :article }

    it { response.should have_status_code(:ok) }
    it_should_behave_like "an article response"
  end

  describe "POST /articles/", focus: true do
    let(:new_article_attrs) do
      attrs = FactoryGirl.attributes_for(:article)
      attrs[:author_ids] = attrs.delete(:authors).map(&:id)
      attrs
    end

    it "should require authentication" do
      expect { post api_articles_url(subdomain: :api), new_article_attrs }.
        to require_authorization
    end

    context "when properly authenticated" do
      before do
        post api_articles_url(subdomain: :api), { article: new_article_attrs },
          'HTTP_AUTHORIZATION' => http_auth(@user)
      end

      it "should have the same fields as the original" do
        subject['published_at'] = DateTime.iso8601(subject['published_at'])
        should include(new_article_attrs.stringify_keys)
      end

      it { response.should have_status_code(:created) }

      its(['id']) { should be_a_kind_of(Integer) }

      it { Article.should have(1).record }

      it_should_behave_like "an article response" do
        subject { ActiveSupport::JSON.decode(response.body) }
        let(:article) { Article.find(subject['id']) }
      end

      it "should set correct location header" do
        response.location.should ==
          api_article_url(subject['slug'], subdomain: :api)
      end
    end
  end

  describe "POST /articles/:id/unpublish" do
    let(:article) { FactoryGirl.create :article }

    it "should require authentication" do
      expect { post unpublish_api_article_url(article.id, subdomain: :api) }.
        to require_authorization
    end

    context "when properly authenticated" do
      before do
        post unpublish_api_article_url(article.id, subdomain: :api), nil,
            { 'HTTP_AUTHORIZATION' => http_auth(@user) }
        article.reload
      end

      it "should be unpublished" do
        article.should_not be_published
      end

      it { response.should have_status_code(:ok) }

      it_should_behave_like "an article response"
    end
  end

  describe "PUT /articles/:id" do
    let(:article_attrs) { FactoryGirl.attributes_for :article }
    let!(:article) { FactoryGirl.create :article, article_attrs }

    it "should require authentication" do
      expect { put api_article_url(article.id, subdomain: :api) }.
        to require_authorization
    end

    describe "update with valid data" do
      let(:valid_attrs) { { title: "Magikarp: Underrated?" } }

      before do
        put api_article_url(article.id, subdomain: :api),
          { article: valid_attrs }, 'HTTP_AUTHORIZATION' => http_auth(@user)
      end

      it { response.should have_status_code(:no_content) }

      it "should have a changed title" do
        article.reload.title.should == valid_attrs[:title]
      end
    end

    describe "update with invalid data" do
      let(:invalid_attrs) { { title: "" } }

      before do
        put api_article_url(article.id, subdomain: :api),
          { article: invalid_attrs }, 'HTTP_AUTHORIZATION' => http_auth(@user)
      end

      it { response.should have_status_code(:unprocessable_entity) }

      it "should respond with validation errors" do
        should include('title')
      end
    end
  end

  describe "DELETE /articles/:id" do
    let!(:article) { FactoryGirl.create :article }

    it "should require authentication" do
      expect { delete api_article_url(article.id, subdomain: :api) }.
        to require_authorization
    end

    context "when properly authenticated" do
      before do
        delete api_article_url(article.id, subdomain: :api), nil,
          { 'HTTP_AUTHORIZATION' => http_auth(@user) }
      end

      it { response.should have_status_code(:no_content) }

      it "should remove the article" do
        Article.should have(:no).records
      end
    end
  end
end
