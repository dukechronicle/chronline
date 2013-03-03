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
  include Rails.application.routes.url_helpers

  before { @article = FactoryGirl.create(:article) }
  subject { @article }

  it { should belong_to :image }
  it { should have_and_belong_to_many :authors }
  it { should validate_presence_of :title }
  it { should accept_values_for(:title, Faker::Lorem.sentence(5)) }
  it "should not allow long titles" do
    should_not accept_values_for(:title, Faker::Lorem.sentence(20))
  end
  it { should validate_presence_of :body }
  it { should validate_presence_of :authors }
  it { should accept_values_for(:teaser, Faker::Lorem.paragraph(2)) }
  it "should not allow long teasers" do
    should_not accept_values_for(:teaser, Faker::Lorem.paragraph(10))
  end

  it { should be_valid }

  it "should be searchable" do
    Article.searchable?.should be_true
  end

  describe "#section" do
    before { subject.section = Taxonomy.new(['News', 'University']) }

    its(:section) { should be_a_kind_of(Taxonomy) }
    its(:section) { should eq Taxonomy.new(['News', 'University']) }

    it "should default to root taxonomy" do
      Article.new.section.should be_root
    end
  end

  describe "#render_body" do
    before { subject.body = '**Pikachu** wrecks everyone. The End.' }

    it "should render the article body with markdown" do
      html = '<p><strong>Pikachu</strong> wrecks everyone. The End.</p>'
      subject.render_body.rstrip.should == html
    end
  end

  describe "#normalize_friendly_id" do
    subject do
      @article.normalize_friendly_id('Ash defeats Gary in Indigo Plateau')
    end

    it "should be lowercased" do
      should match(/[a-z_\d\-]+/)
    end

    it "should contain key words of title" do
      should include('ash')
      should include('defeats')
      should include('gary')
      should include('indigo')
      should include('plateau')
    end

    it "should not have unnecessary words" do
      should_not include('-in-')
    end

    context "long title" do
      subject { @article.normalize_friendly_id('a' * 49 + '-' + 'b' * 50) }
      it { should have_at_most(50).characters }
      it { should_not match(/\-$/) }
    end
  end

  describe "#register_view" do
    let(:key_pattern) { /popularity:[a-z]+:\d{4}-\d{2}-\d{2}/ }

    it "should increment its id in the redis sorted set" do
      $redis.should_receive(:zincrby).with(key_pattern, 1, @article.id)
      @article.register_view
    end

    it "should expire the key in 5 days" do
      timestamp = 5.days.from_now.to_date.to_time.to_i
      $redis.should_receive(:expireat).with(key_pattern, timestamp)
      @article.register_view
    end

    it "should not fail if article is in root taxonomy" do
      @article.section = '/'
      -> {@article.register_view}.should_not raise_error
    end
  end

  describe "::most_commented" do
    let(:articles) { FactoryGirl.create_list(:article, 2) }
    let(:response) do
      articles.zip([10, 20]).map do |article, posts|
        {
          'link' => site_article_url(article, subdomain: 'www',
                                     host: Settings.domain),
          'posts' => posts,
        }
      end
    end

    it "should return tuples of articles with comments in sorted order" do
      Disqus.any_instance.should_receive(:request)
        .with(:threads, :list_hot, limit: 5, forum: Settings.disqus.shortname)
        .and_return({'response' => response})
      Article.most_commented(5).should == articles.zip([10, 20]).reverse
    end

    it "should return an empty array if disqus response is nil" do
      Disqus.any_instance.should_receive(:request)
        .with(:threads, :list_hot, limit: 5, forum: Settings.disqus.shortname)
        .and_return(nil)
      Article.most_commented(5).should == []
    end
  end

  describe "::popular" do
    before(:all) do
      @articles = FactoryGirl.create_list(:article, 4)
      $redis.zincrby("popularity:news:#{Date.today}", 2, @articles[0].id)
      $redis.zincrby("popularity:news:#{Date.today}", 3, @articles[1].id)
      $redis.zincrby("popularity:news:#{Date.today - 1}", 2, @articles[2].id)
      $redis.zincrby("popularity:sports:#{Date.today - 1}", 3, @articles[3].id)
    end

    subject { Article.popular(:news) }

    it "should return articles only articles in the section" do
      should =~ @articles.take(3)
    end

    it "should return articles in descending number of views" do
      should include_in_order(@articles[1], @articles[0])
    end

    it "should rank recent article views more highly than old article views" do
      should include_in_order(@articles[0], @articles[2])
    end

    it "should return no more than the specified number of articles" do
      Article.popular(:news, limit: 2).should have(2).articles
    end
  end

  describe "section scope" do
    let(:articles) do
      articles = FactoryGirl.create_list(:article, 3)
      articles[0].update_attributes(section: '/news/')
      articles[1].update_attributes(section: '/news/university/')
      articles[2].update_attributes(section: '/sports/')
      articles
    end

    subject { Article.section(Taxonomy.new(['News'])) }

    it "should return all articles with a subsection of the given section" do
      should include(articles[0])
      should include(articles[1])
    end

    it "should exclude articles in other sections" do
      should_not include(articles[2])
    end

    it "should be chainable with other query methods" do
      articles = Article.section(Taxonomy.new(['News'])).limit(1)
      articles.should have(1).article
    end
  end

end
