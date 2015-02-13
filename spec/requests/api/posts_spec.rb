require 'spec_helper'

describe Api::PostsController do
  before(:all) { @user = FactoryGirl.create(:admin) }
  after(:all) { @user.destroy }
  subject { ActiveSupport::JSON.decode(response.body) }

  describe "POST /posts" do
    let(:post_attrs) do
      attrs = FactoryGirl.attributes_for(:article)
      attrs[:author_ids] = attrs.delete(:authors).map(&:id)
      attrs
    end

    it "should require authentication" do
      expect { post api_posts_url(subdomain: :api), post_attrs }.
        to require_authorization
    end

    context "when creating an article" do
      before do
        post_attrs[:section] = '/news/university/'
      end

      context "without metadata" do
        before do
          post api_posts_url(subdomain: :api), post_attrs.to_json,
            'HTTP_AUTHORIZATION' => http_auth(@user),
            'CONTENT_TYPE' => 'application/json'
        end

        it { response.should have_status_code(:created) }
      end

      context "with valid metadata" do
        before do
          post_attrs[:metadata] = [
            {embed_url: 'http://www.youtube.com/watch?v=JuYeHPFR3f0'},
            {subtitle: 'Metadata subtitle'}
          ]
          post api_posts_url(subdomain: :api), post_attrs.to_json,
            'HTTP_AUTHORIZATION' => http_auth(@user),
            'CONTENT_TYPE' => 'application/json'
        end

        it { response.should have_status_code(:created) }

        it "should save metadata" do
          subject { ActiveSupport::JSON.decode(response.body) }
          post = Post.find(subject['id'])
          expect(post.embed_code).to eq('JuYeHPFR3f0')
        end

        it "should have overriden fields with metadata" do
          subject { ActiveSupport::JSON.decode(response.body) }
          post = Post.find(subject['id'])
          expect(post.subtitle).to eq(post_attrs[:metadata][1][:subtitle])
        end
      end

      context "with invalid metadata" do
        before do
          post_attrs[:metadata] = [{
            a_bad_attr: true
          }]
          post api_posts_url(subdomain: :api), post_attrs.to_json,
            'HTTP_AUTHORIZATION' => http_auth(@user),
            'CONTENT_TYPE' => 'application/json'
        end

        it { response.should have_status_code(:created) }
      end
    end

    context "when creating a blog post" do
      before do
        post_attrs[:section] = '/pokedex/'
        post api_posts_url(subdomain: :api), post_attrs.to_json,
          'HTTP_AUTHORIZATION' => http_auth(@user),
          'CONTENT_TYPE' => 'application/json'
      end

      it { response.should have_status_code(:created) }
    end
  end

  describe "PUT /posts/:id" do
    let(:post_attrs) do
      attrs = FactoryGirl.attributes_for(:article)
      attrs[:author_ids] = attrs.delete(:authors).map(&:id)
      attrs
    end
    let(:post) { FactoryGirl.create(:article, post_attrs) }

    it "should require authentication" do
      expect { put api_post_url(post.id, subdomain: :api) }.
        to require_authorization
    end

    context "with metadata" do
      let(:valid_attrs) do
        {
          subtitle: "Overridden subtitle",
          metadata: [
            {embed_url: 'http://www.youtube.com/watch?v=JuYeHPFR3f0'},
            {subtitle: 'Metadata subtitle'}
          ]
        }
      end

      before do
        put api_post_url(post.id, subdomain: :api),
          valid_attrs.to_json, 'HTTP_AUTHORIZATION' => http_auth(@user),
          'CONTENT_TYPE' => 'application/json'
      end

      it { expect(response).to have_status_code(:no_content) }

      it "should have saved metadata" do
        expect(post.reload.embed_code).to eq('JuYeHPFR3f0')
      end

      it "should have overriden fields with metadata" do
        expect(post.reload.subtitle).to eq(valid_attrs[:metadata][1][:subtitle])
      end
    end

    context "without metadata" do
      let(:valid_attrs) { { title: "Magikarp: Underrated?" } }

      before do
        put api_post_url(post.id, subdomain: :api),
          valid_attrs.to_json, 'HTTP_AUTHORIZATION' => http_auth(@user),
          'CONTENT_TYPE' => 'application/json'
      end

      it { expect(response).to have_status_code(:no_content) }

      it "should have a changed title" do
        expect(post.reload.title).to eq(valid_attrs[:title])
      end
    end

    context "when changing to a section within the current taxonomy" do
      let(:valid_section) { { section: "/sports/" } }

      before do
        put api_post_url(post.id, subdomain: :api),
          valid_section.to_json, 'HTTP_AUTHORIZATION' => http_auth(@user),
          'CONTENT_TYPE' => 'application/json'
      end

      it { expect(response).to have_status_code(:no_content) }

      it "should update the path correctly" do
        expect(post.reload.section.to_s).to eq("/sports/")
      end
    end

    context "when changing to a section outside the current taxonomy" do
      let(:valid_section) { { section: "/pokedex/" } }

      before do
        put api_post_url(post.id, subdomain: :api),
          valid_section.to_json, 'HTTP_AUTHORIZATION' => http_auth(@user),
          'CONTENT_TYPE' => 'application/json'
      end

      it { expect(response).to have_status_code(:no_content) }

      it "should change the type of the Post" do
        updated_post = Post.find post.id
        expect(updated_post.type).to eq("Blog::Post")
      end

      it "should update the path correctly" do
        updated_post = Post.find post.id
        expect(updated_post.section.to_s).to eq("/pokedex/")
      end

      it "should have the same id" do
        updated_post = Post.find post.id
        expect(updated_post.id).to eq(post.id)
      end
    end
  end
end
