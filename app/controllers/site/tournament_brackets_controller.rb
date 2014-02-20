class Site::TournamentBracketsController < Site::BaseController
  before_filter :authenticate_user!, only: [:edit, :update, :destroy]

  def show
    @taxonomy = Taxonomy.new(:sections, ['Sports'])
    @tournament = Tournament.find(params[:tournament_id])
    authenticate_user! unless @tournament.started?

    @bracket = @tournament.brackets.includes(:user).find(params[:id])
    if @tournament.started? || @bracket.user == current_user
      @games = @tournament.games
        .includes(:team1, :team2)
        .order(:position)
        .to_json(include: [:team1, :team2])
    else
      flash[:error] =
        "You may only see other users' brackets once the tournament starts"
      @forbidden = true
      render status: :forbidden
    end
  end

  def new
    @taxonomy = Taxonomy.new(:sections, ['Sports'])
    @tournament = Tournament.find(params[:tournament_id])
    if user_signed_in?
      check_for_existing(@tournament) and return
    end
    @bracket = @tournament.brackets.build(session[:tournament_bracket])
    @bracket.picks = JSON.parse(@bracket.picks) if @bracket.picks.is_a? String
    @games = @tournament.games
      .includes(:team1, :team2)
      .order(:position)
      .to_json(include: [:team1, :team2])
  end

  def create
    @tournament = Tournament.find(params[:tournament_id])
    unless user_signed_in?
      session[:tournament_bracket] = params[:tournament_bracket]
      session[:user_return_to] =
        new_site_tournament_tournament_bracket_path(@tournament)
      authenticate_user!
    end

    check_for_existing(@tournament) and return

    @bracket = current_user.brackets.build(
      tournament: @tournament,
      picks: JSON.parse(params[:tournament_bracket][:picks])
    )
    if @bracket.save
      flash[:success] = "Your bracket has been created"
      redirect_to [:site, @tournament, @bracket]
    else
      render json: @bracket.errors, status: :unprocessable_entity
    end
  end

  private
  def check_for_existing(tournament)
    @bracket = current_user.brackets
      .find_by_tournament_id(@tournament.id)
    if @bracket
      flash[:notice] = "You may only create one bracket per year"
      redirect_to [:site, @tournament, @bracket]
      true
    end
  end
end
