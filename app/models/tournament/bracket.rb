class Tournament::Bracket < ActiveRecord::Base
  class PicksValidator < ActiveModel::Validator
    def validate(record)
      picks = record.picks
      if !picks.is_a?(Array)
        record.errors[:picks] << "Must be an array of team IDs"
      else
        teams = Tournament::Team.where(id: picks).select(&:id)
        unique_ids = Set.new(teams.map(&:id))
        picks.each do |id|
          unless id.nil? or unique_ids.include? id
            record.errors[:picks] << "#{id} is not a valid team ID"
          end
        end
      end
    end
  end

  attr_accessible :picks, :tournament

  belongs_to :tournament
  belongs_to :user

  # TODO: Switch to Postgres array type on switch to Rails 4
  serialize :picks, JSON

  validates :tournament, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: :tournament_id }
  validates_with PicksValidator

  after_initialize { self.picks ||= [] }

  def complete?
    picks.compact.length == 63
  end

  def rank
    tournament.brackets.where('score > ?', score).count + 1
  end

  def calculate_score
    games = tournament.games.sort_by(&:position)
    self.score = games.zip(picks).reduce(0) do |score, item|
      game = item[0]; pick = item[1]
      if game.final && game.winner.id == pick
        score + 2 ** (game.round - 1)
      else
        score
      end
    end
  end
end
