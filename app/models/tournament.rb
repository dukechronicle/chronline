class Tournament < ActiveRecord::Base
  SLUG_PATTERN = %r([a-z_\-\d]+/\d{4})
  include FriendlyId

  friendly_id :name_and_event, use: [:slugged, :sluggable]

  attr_accessible :name, :event, :start_date

  validates :name, presence: true
  validates :event, presence: true
  validates :start_date, presence: true

  def normalize_friendly_id(s)
    "#{super}/#{start_date.year}"
  end

  private
  def name_and_event
    "#{name} #{event}"
  end
end
