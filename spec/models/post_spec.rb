require 'spec_helper'


describe Post do
  let(:post) { FactoryGirl.build(:article) }
  subject { post }

  it { should belong_to :image }
  it { should validate_presence_of :body }
  it { should validate_presence_of :title }
  it { should allow_value(Faker::Lorem.sentence(5)).for(:title) }
  it { should have_and_belong_to_many :authors }
  it { should validate_presence_of :authors }
  it { should allow_value(Faker::Lorem.paragraph(1)).for(:teaser) }
  it "should not allow long teasers" do
    should_not allow_value(Faker::Lorem.paragraph(10)).for(:teaser)
  end

  describe "default scope" do
    let!(:posts) do
      [
       FactoryGirl.create(:article, published_at: nil),
       FactoryGirl.create(:article, published_at: DateTime.now - 1.second),
       FactoryGirl.create(:article, published_at: DateTime.now + 1.second),
      ]
    end

    subject { Post.all }

    it "should exclude posts with no published_at time" do
      should_not include(posts[0])
    end

    it "should return all posts published in the past" do
      should include(posts[1])
    end

    it "should exclude posts published in the future" do
      should_not include(posts[2])
    end

    it "should use the date at the time of querying" do
      sleep 2
      should include(posts[2])
    end
  end

  describe "::section" do
    let!(:posts) do
      [
       FactoryGirl.create(:article, section: %w(News)),
       FactoryGirl.create(:article, section: %w(News University)),
       FactoryGirl.create(:article, section: %w(News University Academics))
      ]
    end
    subject { Article.section(Taxonomy.new(:sections, %w(News University))) }

    it { should have(2).posts }
    it "should not include posts from parent sections" do
      should_not include(posts[0])
    end
    it "should include posts from the given section" do
      should include(posts[1])
    end
    it "should include posts from child sections" do
      should include(posts[2])
    end
    it "should be chainable with other query methods" do
      subject.limit(1).should have(1).post
    end
  end

  describe "#body_text" do
    before do
      post.body = "<p>{{Image:5}}This paragraph has an embedded image.</p>"
    end

    it "should strip all embedded tags from the post body" do
      subject.body_text.should == "<p>This paragraph has an embedded image.</p>"
    end
  end

  describe "#convert_camayak_tags!" do
    pending "should convert Camayak embedded media to custom tags"
  end

  describe "#embed_url" do
    subject { post.embed_url }

    context "when there is no embed code" do
      before { post.embed_code = "" }
      it { should be_nil }
    end

    context "when embed code is valid" do
      before { post.embed_code = "JuYeHPFR3f0" }
      it { should == "//www.youtube.com/watch?v=JuYeHPFR3f0" }
    end
  end

  describe "#embed_url=" do
    it "should parse and set embed code" do
      post.embed_url = "http://www.youtube.com/watch?v=JuYeHPFR3f0"
      post.embed_code.should == "JuYeHPFR3f0"
    end
  end

  describe "#normalize_friendly_id" do
    before do
      post.published_at = DateTime.new(1999, 11, 10)
      slug = post.normalize_friendly_id('Ash defeats Gary in Indigo Plateau')
      slug =~ %r[^(\d{4})/(\d{2})/(\d{2})/([a-z_\d\-]+)$]
      @year, @month, @day, @slug = $1, $2, $3, $4
    end

    describe "date" do
      subject { Date.new(@year.to_i, @month.to_i, @day.to_i) }

      it "should be the post publication date" do
        should == post.published_at.to_date
      end
    end

    describe "slug" do
      subject { @slug }

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

      context "with long title" do
        subject do
          slug = post.normalize_friendly_id('a' * 49 + '-' + 'b' * 50, 50)
          slug =~ %r[/([a-z_\d\-]+)$]
          $1
        end

        it "should have a limit on the number of characters" do
          should have_at_most(50).characters
        end

        it "should not end with a dash" do
          should_not match(/\-$/)
        end
      end
    end
  end

  describe "#published?" do
    context "when published_at is nil" do
      before { post.published_at = nil }
      it { should_not be_published }
    end

    context "when published_at is in the past" do
      before { post.published_at = Date.today - 1 }
      it { should be_published }
    end

    context "when published_at is in the future" do
      before { post.published_at = Date.today + 1 }
      it { should_not be_published }
    end
  end

  describe "#related" do
    it "should make a MLT query to Solr"
    it "should be an array of posts"
    it "should return no more than the limit of posts"
  end

  describe "#render_body" do
    subject { post.render_body }
    let(:rendered_content) { "Pikachu won't enter his Pokeball." }
    before do
      double = double('EmbeddedMedia')
      double.stub(to_s: rendered_content)
      Post::EmbeddedMedia
        .should_receive(:new)
        .with(post.body)
        .and_return(double)
    end

    it "should use EmbeddedMedia to render the body" do
      should == rendered_content
    end
  end

  describe "#register_view" do
    let(:key_pattern) { /popularity:[a-z]+:[a-z]+:\d{4}-\d{2}-\d{2}/ }
    let(:post) { FactoryGirl.create(:article) }

    it "should increment its id in the redis sorted set" do
      $redis.should_receive(:zincrby).with(key_pattern, 1, post.id)
      post.register_view
    end

    it "should expire the key in 5 days" do
      timestamp = 5.days.from_now.to_date.to_time.to_i
      $redis.should_receive(:expireat).with(key_pattern, timestamp)
      post.register_view
    end

    it "should not fail if article is in root taxonomy" do
      post.section = '/'
      expect { post.register_view }.to_not raise_error
    end
  end

  describe "#section=" do
    subject { post.section }

    context "when called on an article" do
      let(:section) { Taxonomy.new(:sections, %w(Sports)) }

      context "when set to a Taxonomy object" do
        before { post.section = section }
        it { should == section }
      end

      context "when set to a taxonomy string" do
        before { post.section = section.to_s }
        it { should == section }
      end

      context "when set to a taxonomy path array" do
        before { post.section = section.to_a }
        it { should == section }
      end
    end

    context "when called on a blog_post" do
      let(:post) { FactoryGirl.build(:blog_post) }
      let(:section) { Taxonomy.new(:blogs, %w(Pokedex)) }

      context "when set to a Taxonomy object" do
        before { post.section = section }
        it { should == section }
      end

      context "when set to a taxonomy string" do
        before { post.section = section.to_s }
        it { should == section }
      end

      context "when set to a taxonomy path array" do
        before { post.section = section.to_a }
        it { should == section }
      end
    end
  end

  describe "::popular" do
    before(:all) do
      @posts = FactoryGirl.create_list(:article, 4)
      $redis.zincrby("popularity:sections:news:#{Date.today}", 2, @posts[0].id)
      $redis.zincrby("popularity:sections:news:#{Date.today}", 3, @posts[1].id)
      $redis.zincrby("popularity:sections:news:#{Date.today - 1}", 2, @posts[2].id)
      $redis.zincrby("popularity:sections:sports:#{Date.today - 1}", 3, @posts[3].id)
    end
    after(:all) do
      DatabaseCleaner.clean_with :truncation
    end

    subject { Article.popular(:news) }

    it "should return posts only posts in the section" do
      should match_array(@posts.take(3))
    end

    it "should return posts in descending number of views" do
      should include_in_order(@posts[1], @posts[0])
    end

    it "should rank recent article views more highly than old article views" do
      should include_in_order(@posts[0], @posts[2])
    end

    it "should return no more than the specified number of posts" do
      Article.popular(:news, limit: 2).should have(2).posts
    end
  end
end
