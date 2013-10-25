##
# Hacky class to scrape ESPN pages for data. All methods cache the results to
# limit requests to ESPN.
class ESPN

  def standings(url)
    scrape('espn:standings', url) do |document|
      table = document.css('table.tablehead').first
      rows = table.css('tr')
      standings = {}
      current = []
      rows.each do |row|
        columns = row.css('td').map(&:text)
        if row.attr('class').include? 'colhead'
          current = standings[columns[0]] = []
        elsif row.attr('class') =~ /oddrow|evenrow/
          current << [columns[0], columns[1], columns[4]]
        end
      end
      standings
    end
  end

  def game_information(url)
    scrape('espn:game-info', url) do |document|
      overview = document.css('.overview')
      away_team = scrape_team(overview.css('.team-away'))
      home_team = scrape_team(overview.css('.team-home'))
      scores = overview.css('.scoring tr').map do |row|
        column = row.css('td').last
        column && column.text
      end.compact
      away_team[:score] = scores[0]
      home_team[:score] = scores[1]
      {
        away_team: away_team,
        home_team: home_team,
      }
    end
  end

  private
  def scrape(key, url)
    Rails.cache.fetch(key) do
      response = HTTParty.get(url)
      yield Nokogiri::HTML(response.body)
    end
  end

  def scrape_team(elt)
    {
      logo: elt.css('img').attr('src').value,
      name: elt.css('.record h6').text,
    }
  end
end
