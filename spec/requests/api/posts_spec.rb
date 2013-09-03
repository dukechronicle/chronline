require 'spec_helper'

describe Api::PostsController do
  before(:all) { @user = FactoryGirl.create(:user) }
  after(:all) { @user.destroy }

  describe "POST /posts" do
    let(:post_attrs) do
      attrs = FactoryGirl.attributes_for(:article)
      attrs[:author_ids] = attrs.delete(:authors).map(&:id)
      attrs
    end
    subject { response }

    it "should require authentication" do
      expect { post api_posts_url(subdomain: :api), post_attrs }.
        to require_authorization
    end

    context "when creating an article" do
      before do
        post_attrs[:section] = '/news/university/'
        post api_posts_url(subdomain: :api), post_attrs,
          { 'HTTP_AUTHORIZATION' => http_auth(@user) }
      end

      its(:status) { should == Rack::Utils.status_code(:created) }
    end

    context "when creating a blog post" do
      before do
        post_attrs[:section] = '/blog/pokedex/'
        post api_posts_url(subdomain: :api), post_attrs,
          { 'HTTP_AUTHORIZATION' => http_auth(@user) }
      end

      its(:status) { should == Rack::Utils.status_code(:created) }
    end
  end

end
