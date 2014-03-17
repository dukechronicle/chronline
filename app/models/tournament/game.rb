class Tournament::Game < ActiveRecord::Base
  attr_accessible :position, :start_time, :team1, :team2

  belongs_to :tournament
  belongs_to :team1, class_name: 'Tournament::Team'
  belongs_to :team2, class_name: 'Tournament::Team'


  validates :position, presence: true, numericality: {
    greater_than_or_equal_to: 0, less_than: 63
  }
  validates :tournament, presence: true


  def winner
    if final
      score1 > score2 ? team1 : team2
    end
  end

  def game1
    game1_position =
      first_game_in_previous_round + 2 * (position - first_game_in_round)
    tournament.games.find_by_position(game1_position)
  end

  def game2
    game2_position =
      first_game_in_previous_round + 2 * (position - first_game_in_round) + 1
    tournament.games.find_by_position(game2_position)
  end

  def next
    next_position =
      first_game_in_next_round + ((position - first_game_in_round) / 2).floor
    tournament.games.find_by_position(next_position)
  end

  ##
  # Games 0-31 are in round 1
  # Games 32-47 are in round 2
  # Games 48-55 are in round 3 (Sweet 16)
  # Games 56-59 are in round 4 (Elite 8)
  # Games 60-61 are in round 5 (Final 4)
  # Game 62 is in round 6 (Championship)
  #
  def round
    6 - Math.log(63 - position, 2).floor
  end

  def region_id
    if round < 5
      (position - first_game_in_round) / (2 ** (4 - round))
    end
  end

  def first_round?
    position < 32
  end

  def update_teams
    if first_round?
      seeds = [1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15]
      self.team1 = tournament.teams.where(
        region_id: position / 8,
        seed: seeds[2 * (position % 8)],
      ).first
      self.team2 = tournament.teams.where(
        region_id: position / 8,
        seed: seeds[2 * (position % 8) + 1],
      ).first
    else
      self.team1 = game1.winner
      self.team2 = game2.winner
    end
  end

  private
  def first_game_in_next_round
    64 - 2 ** (6 - round)
  end

  def first_game_in_round
    64 - 2 ** (7 - round)
  end

  def first_game_in_previous_round
    64 - 2 ** (8 - round)
  end
end
