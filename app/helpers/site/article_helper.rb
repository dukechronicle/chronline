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

  def truncate_body(article)
    if article.teaser.blank?
      article.render_body
    elsif article.teaser.length <= 200
      article.teaser
    else
      article.teaser[0...article.teaser.rindex(' ', 197)] + '...'
    end
  end

  def photo_credit(image, options={})
    if image.photographer
      name = if options[:include_link]
               link_to(image.photographer.name,
                       site_staff_path(image.photographer))
             else
               image.photographer.name
             end
      if image.attribution.blank?
        name
      else
        image.attribution.sub('?', name)
      end.html_safe
    elsif image.credit
      image.credit
    end
  end

  def mailto_body(article)
    body = <<EOS


--------------------------------------------------------------------------------

Duke Chronicle

#{article.title}

#{byline(article)} | #{display_date(article)}

#{article.teaser}

Visit #{site_article_url(article)} for the full story.
EOS
    URI.escape(body)
  end

  def mailto_subject(article)
    "Duke Chronicle: #{article.title}"
  end

end
