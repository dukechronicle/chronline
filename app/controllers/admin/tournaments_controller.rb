class Admin::TournamentsController < Admin::BaseController
  def index
    @tournaments = Tournament.page(params[:page])
  end

  def show
    @tournament = Tournament.find(params[:id])
    @teams = @tournament.teams.order(:school)
  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def update
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attributes(params[:tournament])
      redirect_to challenge_site_tournament_url(@tournament, subdomain: 'www')
    else
      render 'edit'
    end
  end
end
