class Blog
  class Encoder
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
    serialize :blog, Blog::Encoder.new

    validates :blog, presence: true
  end
end
