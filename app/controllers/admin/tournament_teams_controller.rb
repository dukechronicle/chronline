class Admin::TournamentTeamsController < Admin::BaseController
  def new
    @tournament = Tournament.find(params[:tournament_id])
    @team = @tournament.teams.build
  end

  def create
    @tournament = Tournament.find(params[:tournament_id])
    @team = @tournament.teams.build(tournament_team_params)
    if @team.save
      redirect_to [:admin, @team.tournament]
    else
      render 'new'
    end
  end

  def edit
    @team = Tournament::Team
      .includes(:tournament, :article)
      .find(params[:id])
  end

  def update
    @team = Tournament::Team.find(params[:id])
    if @team.update_attributes(tournament_team_params)
      redirect_to [:edit, :admin, @team.tournament, @team]
    else
      render 'edit'
    end
  end

  private
  def tournament_team_params
    params.require(:tournament_team).permit(
      :article_id, :espn_id, :mascot, :preview, :region_id, :school, :seed,
      :shortname, :school
    )
  end
end
