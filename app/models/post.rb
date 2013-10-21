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


  def self.published
    self
      .where('published_at IS NOT NULL')
      .where(['published_at < ?', DateTime.now])
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

  def render_body
    EmbeddedMedia.new(body).to_s
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

  def square_80x_url
    image.original.url(:square_80x) if image
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
end

# Necessary to avoid autoload namespacing conflict
require_dependency 'blog/post'
