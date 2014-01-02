# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  body       :text
#  subtitle   :string(255)
#  section    :string(255)
#  teaser     :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
#  image_id   :integer
#

require 'spec_helper'


describe Article do
  let(:article) { FactoryGirl.build(:article) }
  subject { article }

  it { Article.should be_searchable }

  describe "::most_commented" do
    include Rails.application.routes.url_helpers

    context "when Disqus response is valid" do
      let(:articles) { FactoryGirl.create_list(:article, 2) }
      let(:articles_with_posts) { articles.zip([10, 20]) }
      let(:response) do
        articles_with_posts.map do |article, posts|
          {
            'link' => site_article_url(
              article, subdomain: 'www', host: ENV['DOMAIN']),
            'posts' => posts,
          }
        end
      end

      before do
        Disqus.any_instance.should_receive(:request)
          .with(:threads, :list_hot, limit: 5, forum: ENV['DISQUS_SHORTNAME'])
          .and_return({'response' => response})
      end

      it "should return tuples of articles with comment count" do
        Article.most_commented(5).should == articles_with_posts
      end
    end

    context "when Disqus response is nil" do
      before do
        Disqus.any_instance.should_receive(:request)
          .with(:threads, :list_hot, limit: 5, forum: ENV['DISQUS_SHORTNAME'])
          .and_return(nil)
      end

      it { Article.most_commented(5).should == [] }
    end
  end
end
