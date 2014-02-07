module BlogPostHelper

  def blog_logo_tag(blog, options = {})
    image_tag "blogs/#{blog.id}-logo.jpg", options
  end

  def blog_banner_tag(blog, options = {})
    image_tag "blogs/#{blog.id}-banner.jpg", options
  end

  def permanent_blog_post_url(blog_post)
    if blog_post.previous_url.present?
      blog_post.previous_url
    else
      site_blog_post_url(blog_post.blog, blog_post.id, subdomain: :www)
    end
  end

  def truncate_text(blog_post)
    read_more_link = link_to(
      "Read more", site_blog_post_path(blog_post.blog, blog_post))
    Nokogiri::HTML::DocumentFragment.parse(
      truncate(
        blog_post.render_body,
        length: 1200,
        separator: '.',
        omission: '... '+ read_more_link
      )
    )
  end

  def blog_options
    Blog.all.map { |blog| [blog.name, blog.id] }
  end

  def recent_blog_posts(blog, limit=5)
    blog.posts.order('published_at DESC').limit(limit)
  end

end
