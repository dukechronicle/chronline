SitemapGenerator::Sitemap.default_host = "http://www.#{ENV['DOMAIN']}"
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['AWS_S3_BUCKET']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.public_path = "tmp/"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/news"
SitemapGenerator::Sitemap.create_index = false
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fog_provider: 'AWS',
  fog_directory: ENV['AWS_S3_BUCKET'],
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
)


SitemapGenerator::Sitemap.create do
  articles = Article
    .where(["published_at >= ?", 2.days.ago])
    .where(block_bots: false)
    .includes(:image)
  articles.find_each do |article|
    images = []
    if article.image
      images << {
        loc: article.image.original.url(:rectangle_636x),
        caption: article.image.caption,
      }
    end

    # TODO: set changefreq
    add(site_article_path(article),
        lastmod: article.updated_at,
        news: {
          publication_name: "Duke Chronicle",
          publication_language: "en",
          title: article.title,
          publication_date: article.published_at,
        },
        images: images,
        )
  end
end
