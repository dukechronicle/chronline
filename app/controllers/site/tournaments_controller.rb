class Site::TournamentsController < Site::BaseController
  def show
    @taxonomy = Taxonomy.new(:sections, ['Sports'])
    @tournament = Tournament
      .includes(games: { team1: :article, team2: :article })
      .find(params[:id])
    @tournament_json = @tournament.to_json(
      include: {
        games: {
          include: {
            team1: { include: :article },
            team2: { include: :article }
          }
        }
      }
    )

    if user_signed_in?
      @bracket = @tournament.brackets.find_by_user_id(current_user)
    end
  end

  def challenge
    @tournament = Tournament.find(params[:id])
  end

  def leaderboard
    @tournament = Tournament.find(params[:id])
    @brackets = @tournament.top_brackets(53)
    fetch_featured_brackets(@tournament)
    if user_signed_in?
      @user_bracket = @tournament.brackets.find_by_user_id(current_user.id)
      @display_user_bracket = @user_bracket &&
        !@brackets.map(&:first).include?(@user_bracket)
    end
  end

  private
  def fetch_featured_brackets(tournament)
    ids = tournament.featured.map { |info| info['id'] }
    brackets = tournament.brackets.includes(:user).where(id: ids)
    brackets = brackets.map do |bracket|
      [bracket.id, bracket]
    end
    brackets = Hash[brackets]
    tournament.featured.each do |info|
      info['bracket'] = brackets[info['id']]
      if info['bracket'].picks[62]
        info['champion'] = Tournament::Team.find(info['bracket'].picks[62])
      end
    end
  end
end
