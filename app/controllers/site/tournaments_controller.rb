class Site::TournamentsController < Site::BaseController
  def show
    @taxonomy = Taxonomy.new(:sections, ['Sports'])
    @tournament = Tournament
      .includes(games: { team1: :article, team2: :article })
      .find(params[:id])
    @tournament_json = @tournament.to_json(
      include: {
        games: {
          include: {
            team1: { include: :article },
            team2: { include: :article }
          }
        }
      }
    )

    if user_signed_in?
      @bracket = @tournament.brackets.find_by_user_id(current_user)
    end
  end

  def challenge
    @tournament = Tournament.find(params[:id])
  end
end
