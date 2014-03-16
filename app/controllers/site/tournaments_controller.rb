class Site::TournamentsController < Site::BaseController
  def show
    @taxonomy = Taxonomy.new(:sections, ['Sports'])
    @tournament = Tournament.find(params[:id])
    if user_signed_in?
      @bracket = @tournament.brackets.find_by_user_id(current_user)
    end
    @games = @tournament.games
      .includes(team1: :article, team2: :article)
      .order(:position)
      .to_json(
        include: {
          team1: { include: :article },
          team2: { include: :article }
        }
      )
  end

  def challenge
    @tournament = Tournament.find(params[:id])
  end
end
