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

class Article < ActiveRecord::Base
  include Postable
  include Searchable

  attr_accessible :previous_id, :subtitle, :section, :teaser, :author_ids
  serialize :section, Taxonomy::Serializer.new

  has_and_belongs_to_many :authors, class_name: "Staff", join_table: :articles_authors

  validates :authors, presence: true
  validates :teaser, length: { maximum: 200 }
  validates_with Taxonomy::Validator, attr: :section

  scope :section, ->(taxonomy) { where('section LIKE ?', "#{taxonomy.to_s}%") }

  self.per_page = 25  # set will_paginate default to 25 articles

  ##
  # Configure articles to be indexed by Solr
  #
  search_facet :author_ids, model: Staff
  search_facet :section

  searchable if: :published_at, include: :authors do
    text :title, stored: true, boost: 2.0, more_like_this: true
    text :content, stored: true, more_like_this: true do
      Nokogiri::HTML(body).text
    end
    time :date, trie: true do
      published_at
    end

    text :author_names do  # Staff names rarely change
      authors.map(&:name)
    end
    integer :author_ids, multiple: true
    string :section do
      section[0]
    end
  end

  ##
  # Record temporarily that this article was viewed by a user. This data is
  # stored in Redis for five days. The data is used to determine popularity of
  # articles in each section. This should be called each time an article is
  # viewed on the main site or on mobile.
  #
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
  #
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
  # Reader for section attribute. Creates a Taxonomy object if section is a
  # string.
  #
  def section
    unless self[:section].is_a?(Taxonomy)
      self[:section] = Taxonomy.new(self[:section])
    end
    self[:section]
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
