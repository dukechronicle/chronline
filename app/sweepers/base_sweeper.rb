module BaseSweeper

  def expire_blog_post_cache(blog_post)
    expire_fragment(
      controller: 'site/blog_posts',
      subdomain: :www,
      action: :index,
      blog_id: blog_post.blog
    )
    unless blog_post.section.parent.root?
      expire_fragment(
        controller: 'site/blog_posts',
        subdomain: :www,
        action: :categories,
        blog_id: blog_post.blog,
        category: blog_post.section.name
      )
    end
    expire_fragment(
      controller: 'site/blog_posts',
      subdomain: :www,
      action: :show,
      blog_id: blog_post.blog,
      id: blog_post
    )
    blog_post.tags.each do |tag|
      expire_fragment(
        controller: 'site/blog_posts',
        subdomain: :www,
        action: :tags,
        blog_id: blog_post.blog,
        tag: tag.name
      )
    end
  end

  def expire_article_cache(article)
    expire_fragment controller: 'site/articles', action: :index, subdomain: :www
    article.section.parents.each do |taxonomy|
      expire_fragment(
        controller: 'site/articles',
        subdomain: :www,
        action: :index,
        section: taxonomy.to_s[1...-1]
      )
    end
    expire_fragment(
      id: article,
      controller: 'site/articles',
      action: :show,
      subdomain: :www,
    )
  end

  def expire_obj_cache(obj)
    class_name = obj.class.name.parameterize(sep = '_')
    send("expire_#{class_name}_cache", obj)
  end

end
