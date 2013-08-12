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
      before { post api_articles_url(subdomain: :api), new_article_data}

      its(:status) { should == created }
      it "should include the data posted" do
        res.except('slug').should include(new_article_data)
      end

      it "should have a slug" do
        res.should include('slug')
      end

      it "should have a well-formed slug" do
        res['slug'].should match(%r[(\d{4}/\d{2}/\d{2}/)?[^/]+])
      end
    end
  end

  describe "POST /articles/:id/unpublish" do
    let(:article_attrs) { FactoryGirl.attributes_for :article }
    let(:article) { FactoryGirl.create :article, article_attrs }
    let(:res) { ActiveSupport::JSON.decode(response.body) }
    subject { response }

    before { post unpublish_api_article_url(article.id, subdomain: :api) }

    it "should be unpublished" do
      article.reload.published?.should be_false
    end
    its(:status) { should == Rack::Utils.status_code(:ok) }
    it "should include the data posted" do
      res.except('slug').should include(article_attrs)
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

      describe "with valid data" do
        let(:valid_attrs) { {title: "Magikarp: Underrated?" } }
        before { put api_article_url(article.id, subdomain: :api), valid_attrs }
        its(:status) { should == Rack::Utils.status_code(:no_content) }
        it "should have a changed title" do
          article.reload.title.should == valid_attrs[:title]
        end
      end

      describe "with invalid data" do
        let(:invalid_attrs) { {title: "" } }
        before { put api_article_url(article.id, subdomain: :api), invalid_attrs }
        it { response.status.should == Rack::Utils.status_code(:bad_request) }
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
    before { delete api_article_url(article.id, subdomain: :api) }

    it { response.status.should == Rack::Utils.status_code(:no_content) }

    it "should remove the article" do
      Article.should have(:no).records
    end
  end
end

def convert_objs_to_ids(hash, key, new_key)
  hash[new_key] = hash.delete(key).map { |obj| obj.id }
  hash
end
