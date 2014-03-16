class Admin::TournamentTeamsController < Admin::BaseController
  def new
    @tournament = Tournament.find(params[:tournament_id])
    @team = @tournament.teams.build
  end

  def create
    @tournament = Tournament.find(params[:tournament_id])
    @team = @tournament.teams.build(params[:tournament_team])
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
    if @team.update_attributes(params[:tournament_team])
      redirect_to [:edit, :admin, @team.tournament, @team]
    else
      render 'edit'
    end
  end
end
