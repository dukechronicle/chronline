# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.dukechronicle.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  add '/articles', :changefreq => 'daily'
  #
  # Add all articles:
  #
  Article.where(["created_at >= ?", 2.days.ago]) do |article|
    add site_article_path(article), :lastmod => article.updated_at, :news => {
      :publication_name => "Duke Chronicle",
      :publication_language => "en",
      :title => article.title,
      :publication_date => article.created_at
    }
  end
end
