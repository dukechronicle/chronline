SitemapGenerator::Sitemap.default_host = "http://www.#{ENV['DOMAIN']}"
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['AWS_S3_BUCKET']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.public_path = "tmp/"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/site"
SitemapGenerator::Sitemap.create_index = true
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fog_provider: 'AWS',
  fog_directory: ENV['AWS_S3_BUCKET'],
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
)


SitemapGenerator::Sitemap.create do

  # Front page
  frontpage = Page.find_by_path('/')
  add(site_root_path,
      priority: 1.0,
      changefreq: 'daily',
      lastmod: frontpage && frontpage.updated_at
      )

  # Article section pages
  Taxonomy.levels.each_with_index do |level, i|
    level.each do |taxonomy|
      add(site_article_section_path(section: taxonomy.to_s[1..-1]),
          changefreq: 'daily',
          priority: 0.8 - 0.2 * i,  # Pretty arbitrary
          )
    end
  end

  # Article URLs
  articles = Article
    .where(block_bots: false)
    .includes(:image)
  articles.find_each do |article|
    images =
      if article.image
        [{
        loc: article.image.original.url(:rectangle_636x),
        caption: article.image.caption,
         }]
      else
        []
      end

    add(site_article_path(article),
        lastmod: article.updated_at,
        changefreq: 'never',
        priority: 0.5,
        images: images,
        )
  end

  # Staff URLs
  Staff.includes(:headshot).find_each do |staff|
    images =
      if staff.headshot
        [{loc: staff.headshot.original.url(:square_200x)}]
      else
        []
      end

    add(site_staff_path(staff),
        priority: 0.5,
        images: images,
        )
  end

  # Special pages
  Page.find_each do |page|
    add(page.path) if page.path.start_with? "/pages/"
  end

  # Newsletter subscribe url
  add site_newsletter_path, changefreq: 'never'

end
