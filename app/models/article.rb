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
  include FriendlyId
  include Rails.application.routes.url_helpers

  attr_accessible :body, :image_id, :previous_id, :subtitle, :section, :slug, :teaser, :title

  friendly_id :title, use: [:slugged, :history]

  belongs_to :image
  has_and_belongs_to_many :authors, class_name: "Staff", join_table: :articles_authors

  validates :body, presence: true
  validates :title, presence: true
  validates :section, presence: true
  validates :authors, presence: true
  validates :teaser, length: {maximum: 200}

  scope :section, ->(taxonomy) {where('section LIKE ?', "#{taxonomy.to_s}%")}

  self.per_page = 25  # set will_paginate default to 25 articles

  searchable do
    text :title, stored: true, boost: 2.0, more_like_this: true
    text :subtitle, stored: true, boost: 1.5, more_like_this: true
    text :body, stored: true, more_like_this: true
    integer :author_ids, :multiple => true
    string :section do
      section[0]
    end
    time :created_at, :trie => true
  end

  # Stolen from http://snipt.net/jpartogi/slugify-javascript/
  def normalize_friendly_id(title, max_chars=50)
    return nil if title.nil?  # record won't save -- title presence is validated
    removelist = %w(a an as at before but by for from is in into like of off on
onto per since than the this that to up via with)
    r = /\b(#{removelist.join('|')})\b/i

    s = title.downcase  # convert to lowercase
    s.gsub!(r, '')
    s.strip!
    s.gsub!(/[^-\w\s]/, '')  # remove unneeded chars
    s.gsub!(/[-\s]+/, '-')   # convert spaces to hyphens
    s[0...max_chars].chomp('-')
  end

  def register_view
    unless section.root?
      # TODO: expire old keys
      key = "popularity:#{section[0].downcase}:#{Date.today}"
      $redis.zincrby(key, 1, id)
    end
  end

  def related(limit)
    Sunspot.more_like_this(self) do
      fields :title, :subtitle, :body
      minimum_term_frequency 5
      paginate per_page: limit
    end.results
  end

  def render_body
    RDiscount.new(body).to_html  # Uses RDiscount markdown renderer
  end

  def section
    Taxonomy.new(self[:section])
  end

  def section=(taxonomy)
    taxonomy = Taxonomy.new(taxonomy) if not taxonomy.is_a?(Taxonomy)
    self[:section] = taxonomy.to_s
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
    slugs = response['response'].map do |thread|
      URI.parse(thread['link']).path =~ %r{/articles?/(.*)}
      [$1, thread['posts']]
    end
    articles = self.where(slug: slugs.map(&:first))
    results = slugs.map do |slug, comments|
      article = articles.find {|article| article.slug == slug}
      [article, comments] unless article.nil?  # TODO: this shouldn't be needed
    end.compact
    results.sort_by! {|slug, comments| -comments}
  end

  ###
  # Helper methods for rendering JSON
  ###

  def thumb_square_s_url
    image.original.url(:thumb_square_s) if image
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
