require 'rss'


Layout.add_schema(:markdown, {
                    "type" => "string",
                    # "description" => "Markdown text",
                    "format" => "multiline",  # for onde.js
                  }) do |markdown_strings|
  markdown_strings.map {|str| RDiscount.new(str).to_html}
end

Layout.add_schema(:article, {
                    "type" => "integer",
                    "display" => "article-picker",
                    "model" => true,
                  }) do |article_ids|
  Article.includes(:authors, :image).find_in_order(article_ids)
end

Layout.add_schema(:disqus_popular, {"type" => "null"}) do |invocations|
  articles = Article.most_commented(7)
  [articles] * invocations.length
end

Layout.add_schema(:columnists, {'type' => 'null'}) do |invocations|
  invocations.map do |_|
    # TODO: eager load the most recent n articles
    Staff.includes(:headshot).where(columnist: true).order(:name)
  end
end

Layout.add_schema(:popular, {
                    'type' => 'string',
                    'enum' => Taxonomy.main_sections.map {|t| t.name.downcase},
                  }) do |sections|
  sections.map do |section|
    Article.popular(section, limit: 7)
  end
end

Layout.add_schema(:section_articles, {
                    'type' => 'string',
                  }) do |sections|
  sections.map do |section|
    # TODO: Magic number
    Article.limit(7).order('created_at DESC').find_by_section(section)
  end
end

Layout.add_schema(:rss, {'type' => 'string'}) do |feeds|
  feeds.map do |feed_url|
    feed = HTTParty.get(feed_url).body
    RSS::Parser.parse(feed).items
  end
end

Layout.add_schema(:image, {
                    "type" => "integer",
                    "display" => "image-picker"
                  }) do |image_ids|
  Image.includes(:photographer).find_in_order(image_ids)
end
