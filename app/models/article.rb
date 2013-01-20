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

  attr_accessible :body, :image_id, :subtitle, :section, :slug, :teaser, :title

  friendly_id :title, use: [:slugged, :history]

  validates :body, presence: true
  validates :title, presence: true
  validates :section, presence: true
  validates :authors, presence: true

  has_and_belongs_to_many :authors
  belongs_to :image

  self.per_page = 25  # set will_paginate default to 25 articles

  searchable do
    text :title, :boost => 2.0
    text :subtitle, :boost => 1.5
    text :body
    string :section
    time :created_at
    time :updated_at
  end

  def disqus(host)
    {
      production: Rails.env.production?,
      shortname: Settings.disqus.shortname,
      identifier: id,  # TODO: should be old unique identifier for backwards compatibility
      title: title,
      url: site_article_url(self, subdomain: 'www', host: host),
    }
  end

  # Stolen from http://snipt.net/jpartogi/slugify-javascript/
  def normalize_friendly_id(title, max_chars=100)
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
    # TODO: expire old keys
    key = "popularity:#{section[0].downcase}:#{Date.today}"
    $redis.zincrby(key, 1, id)
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

  def self.find_by_section(taxonomy)
    self.where('section LIKE ?', "#{taxonomy.to_s}%")
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
    self.find_in_order(article_ids)
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
