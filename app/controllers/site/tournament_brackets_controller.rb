class Site::TournamentBracketsController < Site::BaseController
  def show
    @taxonomy = Taxonomy.new(:sections, ['Sports'])
    @tournament = Tournament.find(params[:tournament_id])
    @bracket = @tournament.brackets.find(params[:id])
    @games = @tournament.games
      .includes(:team1, :team2)
      .order(:position)
      .to_json(include: [:team1, :team2])
  end

  def new
    @taxonomy = Taxonomy.new(:sections, ['Sports'])
    @tournament = Tournament.find(params[:tournament_id])
    if user_signed_in?
      @bracket = current_user.brackets
        .find_by_tournament_id(@tournament.id)
      if @bracket
        flash[:notice] = "You may only create one bracket per year"
        redirect_to [:site, @tournament, @bracket]
        return
      end
    end
    @games = @tournament.games
      .includes(:team1, :team2)
      .order(:position)
      .to_json(include: [:team1, :team2])
  end

  def create
    unless user_signed_in?
      render json: "User is not signed in", status: :unauthorized
      return
    end
    @tournament = Tournament.find(params[:tournament_id])
    @bracket = current_user.brackets.build(
      tournament: @tournament,
      picks: params[:tournament_bracket][:picks]
    )
    if @bracket.save
      render json: @bracket, include: :tournament
    else
      render json: @bracket.errors, status: :unprocessable_entity
    end
  end
end
