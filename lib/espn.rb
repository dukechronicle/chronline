class ESPN

  def standings(url)
    response = HTTParty.get(url)
    doc = Nokogiri::HTML(response.body)
    table = doc.css('table.tablehead').first
    rows = table.css('tr')
    standings = {}
    current = []
    rows.each do |row|
      columns = row.css('td').map(&:text)
      if row.attr('class').include? 'colhead'
        current = standings[columns[0]] = []
      elsif row.attr('class') =~ /oddrow|evenrow/
        current << columns[0..1]
      end
    end
    standings
  end

end
