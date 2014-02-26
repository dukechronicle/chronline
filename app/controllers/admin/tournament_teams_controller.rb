class Admin::TournamentTeamsController < Admin::BaseController
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
