# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Settings.domain
SitemapGenerator::Sitemap.sitemaps_host = "http://s3.amazonaws.com/"+Settings.aws.bucket
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/news"

SitemapGenerator::Sitemap.create do
  add '/articles', :changefreq => 'daily', :news => {
    :publication_name => "Duke Chronicle",
    :publication_language => "en"
  }

  Article.where(["created_at >= ?", 2.days.ago]) do |article|
    add site_article_path(article), :lastmod => article.updated_at, :news => {
      :publication_name => "Duke Chronicle",
      :publication_language => "en",
      :title => article.title,
      :publication_date => article.created_at
    }
  end
end
