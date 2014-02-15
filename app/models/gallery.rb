class Gallery < ActiveRecord::Base
  SLUG_PATTERN = %r[(\d{4}/\d{2}/\d{2}/)?[a-z_\d\-]+]
  include FriendlyId

  friendly_id :name, use: [:slugged, :history]

  self.primary_key = :gid

  attr_accessible :name, :gid, :description, :section, :photoshelter_images, :date

  validates :name, presence: true
  validates :gid, presence: true, uniqueness: true

  def get_gallery_images
    PhotoshelterImage.find_all_by_gid(gid)
  end

  # replaces all sequences on non-alphanumeric characters with a dash
  # used to get the proper url for the photoshelter buy page
  def photoshelter_slug
    name.strip.gsub(/[^[:alnum:]]+/, "-")
  end

  def credit
    if get_gallery_images.size > 0
      get_gallery_images.first.credit
    end
  end

  def empty?
    get_gallery_images.empty?
  end

  # largely copied from post.rb
  def normalize_friendly_id(name, max_chars=100)
    return nil if name.nil?  # record won't save -- name presence is validated
    removelist = %w(a an as at before but by for from is in into like of off on
                    onto per since than the this that to up via with)
    r = /\b(#{removelist.join('|')})\b/i

    s = name.downcase  # convert to lowercase
    s.gsub!(r, '')
    s.strip!
    s.gsub!(/[^-\w\s]/, '')  # remove unneeded chars
    s.gsub!(/[-\s]+/, '-')   # convert spaces to hyphens
    s = s[0...max_chars].chomp('-')

    slug = (date || Date.today).strftime('%Y/%m/%d/') + s
    puts slug
    slug
  end

  # has_many Gallery::Images, get #images method

  # tags : gem

  # related articles : belongs_to relation

  # section

end
