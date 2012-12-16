module Site::ArticleHelper

  def byline(article)
    article.authors.map do |author|
      link_to author.name, "hi there"  # TODO: use author url helper
    end.join(', ').html_safe
  end

end
