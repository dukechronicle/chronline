module TournamentsHelper
  def tournament_json(tournament)
    tournament.to_json(tournament_json_options)
  end

  def tournament_bracket_json(bracket)
    bracket.to_json(tournament_bracket_json_options(bracket))
  end

  def tournament_json_options
    {
      include: {
        games: {
          include: {
            team1: { include: :article },
            team2: { include: :article }
          }
        }
      }
    }
  end

  def tournament_bracket_json_options(bracket)
    {
      include: { tournament: tournament_json_options },
      properties: { editable: ->(bracket) { current_user == bracket.user } }
    }
  end
end
