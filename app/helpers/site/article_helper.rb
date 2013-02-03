module Site::ArticleHelper

  def byline(article, options={})
    article.authors.map do |author|
      if options[:include_links]
        link_to author.name, site_staff_path(author)
      else
        author.name
      end
    end.join(', ').html_safe
  end

  def display_date(article, format="%B %e, %Y")
    article.created_at.strftime(format)
  end

  def truncate_body(article)
    if article.teaser.length <= 200
      article.teaser
    else
      article.teaser[0...article.teaser.rindex(' ', 197)] + '...'
    end
  end

end
