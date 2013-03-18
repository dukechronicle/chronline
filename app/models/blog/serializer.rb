class Blog
  class Serializer
    def load(blog_id)
      Blog.find(blog_id)
    end

    def dump(blog)
      blog.id
    end
  end
end
