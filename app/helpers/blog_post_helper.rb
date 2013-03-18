module BlogPostHelper

  def permanent_blog_post_url(blog_post)
    site_blog_post_url(blog_post.blog, blog_post.id, subdomain: :www)
  end

  def blog_options
    Blog.all.map {|blog| [blog.name, blog.id]}
  end

end
