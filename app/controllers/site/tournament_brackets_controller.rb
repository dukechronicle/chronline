class Site::TournamentBracketsController < Site::BaseController
  def new
    @taxonomy = Taxonomy.new(:sections, ['Sports'])
    @tournament = Tournament.find(params[:tournament_id])
    @games = @tournament.games
      .includes(:team1, :team2)
      .order(:position)
      .to_json(include: [:team1, :team2])
  end
end
