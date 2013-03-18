class Blog
  class Serializer
    def load(blog_id)
      Blog.find(blog_id)
    end

    def dump(blog)
      blog.id
    end
  end

  class Post < ActiveRecord::Base
    include Postable

    self.table_name = :blog_posts

    # Hacks so that url_for works correctly for blog posts
    self.model_name.instance_variable_set(:@singular_route_key, "post")
    self.model_name.instance_variable_set(:@route_key, "posts")

    attr_accessible :blog
    serialize :blog, Blog::Serializer.new

    belongs_to :author, class_name: "Staff"

    validates :blog, presence: true
    validates :author, presence: true


    def blog=(blog)
      blog = Blog.find(blog) unless blog.is_a?(Blog)
      super(blog)
    end

  end
end
