ESPN_URL = "http://espn.go.com/mens-college-basketball/team/_/id/"

# TODO: This script should go die
namespace :espn do

  task scrape_scores: :environment do
    tournament = Tournament.last
    games = tournament.games
      .includes(:team1)
      .where(final: false).where('start_time < ?', DateTime.now)
    updated = false
    games.find_each do |game|
      if scrape(game)
        game.final = true
        game.save!

        next_game = game.next
        if next_game
          if game.id == next_game.game1.id
            next_game.update_attributes!(team1: game.winner)
          end
          if game.id == next_game.game2.id
            next_game.update_attributes!(team2: game.winner)
          end
        end

        updated = true
      end
    end

    if updated
      tournament.brackets.find_each do |bracket|
        bracket.calculate_score
        bracket.save!
      end
    end
  end

end

def scrape(game)
  response = HTTParty.get(ESPN_URL + game.team1.espn_id.to_s)
  document = Nokogiri::HTML(response.body)
  if document.css('.winner').length > 0
    rows = document.css('.scoring tr')
    scrape_row(game, rows[1])
    scrape_row(game, rows[2])
    true
  else
    false
  end
end

def scrape_row(game, row)
  if row.css('th a').attr('href').value =~ /#{ESPN_URL}(\d+)/
    id = $1.to_i
    score = row.css('b').text.to_i
    if game.team1.espn_id == id
      game.score1 = score
    end
    if game.team2.espn_id == id
      game.score2 = score
    end
  end
end
