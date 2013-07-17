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

require_dependency 'staff'


class Article < ActiveRecord::Base
  include Postable

  attr_accessible :previous_id, :subtitle, :section, :teaser
  serialize :section, Taxonomy::Serializer.new

  has_and_belongs_to_many :authors, class_name: "Staff", join_table: :articles_authors

  validates :section, presence: true
  validates :authors, presence: true
  validates :teaser, length: {maximum: 200}

  scope :section, ->(taxonomy) { where('section LIKE ?', "#{taxonomy.to_s}%") }

  self.per_page = 25  # set will_paginate default to 25 articles

  searchable if: :published_at, include: :authors do
    text :title, stored: true, boost: 2.0, more_like_this: true
    text :body, stored: true, more_like_this: true
    text :author_names do  # Staff names rarely change
      authors.map(&:name)  # TODO: show staff records if name is searched
    end
    integer :author_ids, multiple: true
    string :section do
      section[0]
    end
    time :published_at, trie: true
  end

  ##
  # Record temporarily that this article was viewed by a user. This data is
  # stored in Redis for five days. The data is used to determine popularity of
  # articles in each section. This should be called each time an article is
  # viewed on the main site or on mobile.

  def register_view
    unless section.root?
      key = "popularity:#{section[0].downcase}:#{Date.today}"
      timestamp = 5.days.from_now.to_date.to_time.to_i
      $redis.multi do
        $redis.zincrby(key, 1, id)
        $redis.expireat(key, timestamp)
      end
    end
  end

  ##
  # Search for articles with related content. Uses Solr to query for relevance.
  # Returns the top +limit+ articles.

  def related(limit)
    search = Sunspot.more_like_this(self) do
      fields :title, :body
      minimum_term_frequency 5
      paginate per_page: limit
    end
    # Eager load authors
    search.data_accessor_for(self.class).include = :authors
    search.results
  end

  ##
  # Set article section. Creates a Taxonomy object if given a string argument.

  def section=(taxonomy)
    taxonomy = Taxonomy.new(taxonomy) unless taxonomy.is_a?(Taxonomy)
    super(taxonomy)
  end

  def self.popular(section, options={})
    limit = options[:limit] || 10
    popular = {}
    articles = fetch_popular_from_redis(section, limit)
    articles.each_with_index do |level, days|
      level.each do |pair|
        id, score = pair.map(&:to_i)
        popular[id] = 0.0 if not popular.has_key?(id)
        popular[id] += score / (days + 1)
      end
    end
    article_ids = popular.to_a.sort {|a, b| b[1] <=> a[1]}
      .take(limit).map(&:first)
    self.find_in_order(article_ids).compact
  end

  def self.most_commented(limit)
    disqus = Disqus.new(Settings.disqus.api_key)
    response = disqus.request(:threads, :list_hot, limit: limit,
                              forum: Settings.disqus.shortname)
    return [] if response.nil?
    slugs = response['response'].map do |thread|
      URI.parse(thread['link']).path =~ %r{/articles?/(.*)}
      [$1, thread['posts']]
    end
    articles = self.published.where(slug: slugs.map(&:first))
    slugs.map do |slug, comments|
      article = articles.find {|article| article.slug == slug}
      [article, comments] unless article.nil?  # TODO: this shouldn't be needed
    end.compact
  end


  ###
  # Helper methods for rendering JSON
  ###

  def thumb_square_s_url
    image.original.url(:square_80x) if image
  end

  private

  def self.fetch_popular_from_redis(section, limit)
    $redis.multi do
      5.times do |i|
        key = "popularity:#{section}:#{Date.today - i}"
        $redis.zrevrangebyscore(key, "+inf", 0, with_scores: true,
                                limit: [0, limit])
      end
    end
  end

end
