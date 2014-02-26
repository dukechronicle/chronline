class Admin::TournamentsController < Admin::BaseController
  def index
    @tournaments = Tournament.page(params[:page])
  end

  def show
    @tournament = Tournament.find(params[:id])
    @teams = @tournament.teams.order(:school)
  end
end
