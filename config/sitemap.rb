# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.#{Settings.domain}"
SitemapGenerator::Sitemap.sitemaps_host = "http://#{Settings.aws.bucket}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.public_path = "tmp/"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/full"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

SitemapGenerator::Sitemap.create do
  add '/articles', :changefreq => 'daily'
  Article.for_each do |article|
    images = []
    if article.image
      images << {
        loc: article.image.original.url(:large_rect),
        caption: article.image.caption,
      }
    end
    
    add(site_article_path(article), 
      lastmod: article.updated_at, 
      images: images,
      )
  end
end
