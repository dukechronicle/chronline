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

end
