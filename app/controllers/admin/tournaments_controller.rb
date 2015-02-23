class Admin::TournamentsController < Admin::BaseController
  def index
    @tournaments = Tournament.page(params[:page])
  end

  def show
    @tournament = Tournament.find(params[:id])
    @teams = @tournament.teams.order(:school)
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    if @tournament.save
      redirect_to admin_tournaments_path
    else
      render 'new'
    end
  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def update
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attributes(tournament_params)
      redirect_to challenge_site_tournament_url(@tournament, subdomain: 'www')
    else
      render 'edit'
    end
  end

  private
  def tournament_params
    params.require(:tournament).permit(
      :event, :name, :start_date, :region0, :region1, :region2, :region3,
      :challenge_text
    )
  end
end
