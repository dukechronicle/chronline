# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.#{Settings.domain}"
SitemapGenerator::Sitemap.sitemaps_host = "http://#{Settings.aws.bucket}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.public_path = "tmp/"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/news"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

SitemapGenerator::Sitemap.create do
  Article.all do |article| #where(["created_at >= ?", 2.days.ago]) do |article|
    p article.title
    add(site_article_path(article),
        lastmod: article.updated_at,
        news: news_information(article),
        image: image_information(article),
        )
  end
end

def news_information(article)
  {
    publication_name: "Duke Chronicle",
    publication_language: "en",
    title: article.title,
    publication_date: article.created_at
  }
end

def image_information(article)
  return [] unless article.image
  [{
     loc: article.image.original.url(:large_rect),
     caption: article.caption,
  }]
end
