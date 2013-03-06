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

    attr_accessible :blog
    serialize :blog, Blog::Serializer.new

    validates :blog, presence: true

    def blog=(blog)
      blog = Blog.find(blog) unless blog.is_a?(Blog)
      super(blog)
    end

  end
end
