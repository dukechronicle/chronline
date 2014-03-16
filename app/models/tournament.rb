class Tournament < ActiveRecord::Base
  SLUG_PATTERN = %r([a-z_\-\d]+/\d{4})
  include FriendlyId

  friendly_id :name_and_event, use: [:slugged, :sluggable]

  attr_accessible :name, :event, :start_date, :challenge_text

  has_many :teams, class_name: 'Tournament::Team', dependent: :destroy
  has_many :games, class_name: 'Tournament::Game', dependent: :destroy
  has_many :brackets, class_name: 'Tournament::Bracket', dependent: :destroy

  validates :name, presence: true
  validates :event, presence: true
  validates :start_date, presence: true

  def normalize_friendly_id(s)
    "#{super}/#{year}"
  end

  def year
    start_date.year
  end

  def full_name
    "#{name} #{event} #{year}"
  end

  def started?
    DateTime.now > start_date
  end

  private
  def name_and_event
    "#{name} #{event}"
  end
end
