# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.dukechronicle.com"

SitemapGenerator::Sitemap.create do
  add '/articles', :changefreq => 'daily'
  Article.all do |article|
    images = []
    if article.image
      images << {
        loc: article.image.original.url(:large_rect),
        caption: article.image.caption,
      }
    end
    
    add(site_article_path(article), 
      lastmod: article.updated_at, 
      news:{
        publication_name: "Duke Chronicle",
        publication_language: "en",
        title: article.title,
        publication_date: article.created_at.iso8601,
      },
      images: images,
      )
  end
end
