module Postable
  SLUG_PATTERN = %r[(\d{4}/\d{2}/\d{2}/)?[a-z_\d\-]+]


  def self.included(base)
    base.send(:include, FriendlyId)
    base.friendly_id(:title, use: [:slugged, :history])

    base.send(:include, InstanceMethods)
    base.attr_accessible :body, :image_id, :title, :published_at
    base.belongs_to :image

    base.validates :body, presence: true
    base.validates :title, presence: true, length: {maximum: 90}
  end

  def render_body
    body
  end

  # Can't define them directly, as this must be included after FriendlyId
  # so that normalize_friendly_id is not overridden
  module InstanceMethods

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

  end

end
