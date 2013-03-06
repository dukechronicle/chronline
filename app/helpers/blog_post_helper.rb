module BlogPostHelper

  def blog_options
    Blog.all.map {|blog| [blog.name, blog.id]}
  end

end
