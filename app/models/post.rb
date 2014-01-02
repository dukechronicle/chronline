class Post < ActiveRecord::Base
  SLUG_PATTERN = %r[(\d{4}/\d{2}/\d{2}/)?[a-z_\d\-]+]
  include FriendlyId

  self.table_name = :articles

  friendly_id :title, use: [:slugged, :history]

  attr_accessible :author_ids, :body, :image_id, :previous_id, :published_at,
    :section, :subtitle, :teaser, :title, :embed_code, :embed_url

  belongs_to :image
  has_and_belongs_to_many :authors, class_name: 'Staff',
    join_table: :posts_authors

  validates :body, presence: true
  validates :title, presence: true
  validates :authors, presence: true
  validates :teaser, length: { maximum: 200 }

  scope :section, ->(taxonomy) { where('section LIKE ?', "#{taxonomy.to_s}%") }

  def self.default_scope
    self
      .where('published_at IS NOT NULL')
      .where(['published_at < ?', DateTime.now])
  end

  def convert_camayak_tags!
    document = Nokogiri::HTML::DocumentFragment.parse(body)
    document.css('.oembed').each do |camayak_tag|
      url = camayak_tag.attr('data-camayak-embed-url')
      provider =
        case url
        when %r[^https?://www\.youtube\.com/]
          'Youtube'
        when %r[^https?://twitter\.com/]
          'Twitter'
        when %r[^https?://soundcloud\.com/]
          'Soundcloud'
        when %r[^https?://instagram\.com/]
          'Instagram'
        end
      unless provider.nil?
        camayak_tag.replace("{{#{provider}:#{url}}}")
      end
    end
    self.body = document.to_html
  end

  # Stolen from http://snipt.net/jpartogi/slugify-javascript/
  def normalize_friendly_id(title, max_chars=100)
    return nil if title.nil?  # record won't save -- title presence is validated
    removelist = %w(a an as at before but by for from is in into like of off on
onto per since than the this that to up via with)
    r = /\b(#{removelist.join('|')})\b/i

    s = title.downcase  # convert to lowercase
    s.gsub!(r, '')
    s.strip!
    s.gsub!(/[^-\w\s]/, '')  # remove unneeded chars
    s.gsub!(/[-\s]+/, '-')   # convert spaces to hyphens
    s = s[0...max_chars].chomp('-')

    (published_at || Date.today).strftime('%Y/%m/%d/') + s
  end

  def published?
    not published_at.nil? and published_at < DateTime.now
  end

  ##
  # Search for posts with related content. Uses Solr to query for relevance.
  # Returns the top +limit+ articles.
  #
  def related(limit)
    search = Sunspot.more_like_this(self) do
      fields :title, :content
      with(:date).greater_than(published_at - 1.week) unless published_at.nil?
      with(:date).less_than(published_at + 1.week) unless published_at.nil?
      paginate per_page: limit
    end
    # HAX: Eager load authors
    search.data_accessor_for(self.class).include = :authors
    search.results
  end

  def render_body
    EmbeddedMedia.new(body).to_s
  end

  def body_text
    body.gsub(/{{[^\}]*}}/, '')
  end

  def convert_camayak_tags!
    document = Nokogiri::HTML::DocumentFragment.parse(body)
    document.css('.oembed').each do |camayak_tag|
      url = camayak_tag.attr('data-camayak-embed-url')
      provider =
        case url
        when %r[^https?://www\.youtube\.com/]
          'Youtube'
        when %r[^https?://twitter\.com/]
          'Twitter'
        when %r[^https?://soundcloud\.com/]
          'Soundcloud'
        when %r[^https?://instagram\.com/]
          'Instagram'
        end
      unless provider.nil?
        camayak_tag.replace("{{#{provider}:#{url}}}")
      end
    end
  end

  def square_80x_url
    image.original.url(:square_80x) if image
  end

  def self.most_commented(limit)
    disqus = Disqus.new(ENV['DISQUS_API_KEY'])
    response = disqus.request(
      :threads, :list_hot, limit: limit, forum: ENV['DISQUS_SHORTNAME'])
    return [] if response.nil?
    slugs = response['response'].map do |thread|
      URI.parse(thread['link']).path =~ %r{/articles?/(.*)}
      [$1, thread['posts']]
    end
    articles = self.where(slug: slugs.map(&:first))
    slugs.map do |slug, comments|
      article = articles.find { |article| article.slug == slug }
      [article, comments] unless article.nil?  # TODO: this shouldn't be needed
    end.compact
  end

  ##
  # Writer for section attribute. Creates a Taxonomy object if section is a
  # string.
  #
  def section=(section)
    unless section.is_a?(Taxonomy)
      section = Taxonomy.new(@@taxonomy, section)
    end
    super(section)
  end

  def embed_url(params = {})
    if embed_code.present?
      params[:v] = embed_code
      uri = URI::Generic.build(
        host: 'www.youtube.com',
        path: '/watch',
        query: URI.encode_www_form(params),
      )
      uri.to_s
    end
  end

  def embed_url=(url)
    if url.present?
      uri = URI.parse(url)
      params = Hash[URI.decode_www_form(uri.query)]
      self.embed_code = params['v']
    else
      self.embed_code = nil
    end
  end

  def self.taxonomy=(taxonomy)
    @@taxonomy = taxonomy
    validates_with Taxonomy::Validator, attr: :section, taxonomy: taxonomy
    serialize :section, Taxonomy::Serializer.new(taxonomy)
  end
  private_class_method :taxonomy=
end

# Necessary to avoid autoload namespacing conflict
require_dependency 'blog/post'
