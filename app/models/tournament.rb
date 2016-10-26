class Tournament < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include FriendlyId

  SLUG_PATTERN = %r([a-z_\-\d]+/\d{4})

  friendly_id :name_and_event, use: [:slugged, :chronSlug]


  attr_accessible :name, :event, :start_date, :challenge_text
  # TODO: Use Postgres array type on switch to Rails 4
  attr_accessible :region0, :region1, :region2, :region3

  has_many :teams, class_name: 'Tournament::Team', dependent: :destroy
  has_many :games, class_name: 'Tournament::Game', dependent: :destroy
  has_many :brackets, class_name: 'Tournament::Bracket', dependent: :destroy

  validates :name, presence: true
  validates :event, presence: true
  validates :start_date, presence: true
  validates :region0, presence: true
  validates :region1, presence: true
  validates :region2, presence: true
  validates :region3, presence: true

  # TODO: Switch to Postgres array type on switch to Rails 4
  # This is an array of hashes, with the shape:
  # {
  #   id: <bracket id>,
  #   position: <description of person>,
  #   headshot: <photo headshot id>
  # }
  serialize :featured, JSON

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

  def top_brackets(limit)
    brackets = self.brackets.includes(:user).order('score DESC').limit(limit)

    rank = 1
    ranks = brackets.each_with_index.map do |bracket, i|
      if i > 0 && bracket.score < brackets[i - 1].score
        rank = i + 1
      end
      rank
    end
    brackets.zip(ranks, fetch_champions(brackets))
  end

  def update_brackets!
    self.brackets
      .includes(tournament: { games: [:team1, :team2] })
      .find_each do |bracket|
      bracket.calculate_score
      bracket.save!
    end
  end

  private
  def name_and_event
    "#{name} #{event}"
  end

  def fetch_champions(brackets)
    ids = brackets.map { |bracket| bracket.picks[62] }.compact
    teams = Tournament::Team.where(id: ids)
    teams = teams.map { |team| [team.id, team] }
    teams = Hash[teams]
    brackets.map { |bracket| teams[bracket.picks[62]] }
  end
end
