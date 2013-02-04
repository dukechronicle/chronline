# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.#{Settings.domain}"
SitemapGenerator::Sitemap.sitemaps_host = "http://#{Settings.aws.bucket}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.public_path = "tmp/"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/news"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

SitemapGenerator::Sitemap.create do
  Article.includes(:image, :authors).where(["created_at >= ?", 2.days.ago])
    .each do |article|
    news = {
      publication_name: "Duke Chronicle",
      publication_language: "en",
      title: article.title,
      publication_date: article.created_at
    }

    images = []
    if article.image
      images << {
        loc: article.image.original.url(:large_rect),
        caption: article.image.caption,
      }
    end

    add(site_article_path(article),
        lastmod: article.updated_at,
        news: news,
        images: images,
        )
  end
end
