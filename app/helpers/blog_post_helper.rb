module BlogPostHelper

  def permanent_blog_post_url(blog_post)
    site_blog_post_url(blog_post.blog, blog_post.id, subdomain: :www)
  end

  def blog_options
    Blog.all.map {|blog| [blog.name, blog.id]}
  end

  def recent_blog_posts(blog, limit=5)
    Blog::Post.where(blog: blog.id).order('created_at DESC').limit(limit)
  end

end
