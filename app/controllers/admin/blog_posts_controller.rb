class Admin::BlogPostsController < Admin::BaseController

  def new
    @blog_post = BlogPost.new
  end

end
