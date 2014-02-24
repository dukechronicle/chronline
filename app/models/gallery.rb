class Gallery < ActiveRecord::Base
  SLUG_PATTERN = %r[(\d{4}/\d{2}/\d{2}/)?[a-zA-Z_\d\.\-]+]
  include FriendlyId
  friendly_id :name, use: [:slugged, :history, :chronSlug]

  self.primary_key = :gid
  self.per_page = 25

  attr_accessible :name, :gid, :description, :section, :images, :date

  has_many :images, class_name: "Gallery::Image", primary_key: "gid",
           foreign_key: "gid", dependent: :destroy
  validates :name, presence: true
  validates :gid, presence: true, uniqueness: true

  scope :nonempty, -> { joins(:images).uniq }
  # replaces all sequences on non-alphanumeric characters with a dash
  # used to get the proper url for the photoshelter buy page
  def photoshelter_slug
    name.strip.gsub(/[^[:alnum:]]+/, "-")
  end

  def credit
    if images.size > 0
      images.first.credit
    end
  end

  def empty?
    images.empty?
  end

  # largely copied from post.rb
  def normalize_friendly_id(name, max_chars=100)
    s = super 
    (date || Date.today).strftime('%Y/%m/%d/') + s
  end

end
