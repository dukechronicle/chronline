class Blog
  class Serializer
    def load(blog)
      Blog.find(blog) unless blog.nil?
    end

    def dump(blog)
      blog.id
    end
  end
end
