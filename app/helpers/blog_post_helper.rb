module BlogPostHelper

  def blog_options
    Settings.blogs.marshal_dump.map {|id, blog| [blog.name, id]}
  end

end
