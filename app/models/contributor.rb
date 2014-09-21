class Contributor
  class << self
    def all
      query do |contributors|
        contributors.map { |c| c.slice("login", "avatar_url", "html_url") }
      end
    end

    private
    def query
      Rails.cache.fetch("contributors") do
        yield HTTParty.get(
          "https://api.github.com/repos/#{ENV['GITHUB_REPO']}/contributors",
          headers: {"User-Agent" => ENV['GITHUB_REPO']}).to_a
      end
    end
  end
end
