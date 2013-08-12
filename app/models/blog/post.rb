class Blog
  class Post < ActiveRecord::Base
    require_dependency 'blog/post/search'
    include Postable

    self.table_name = :blog_posts

    # HAX: needed so that url_for works correctly for blog posts
    self.model_name.instance_variable_set(:@singular_route_key, "post")
    self.model_name.instance_variable_set(:@route_key, "posts")

    attr_accessible :blog, :tag_list
    serialize :blog, Blog::Serializer.new

    acts_as_taggable

    belongs_to :author, class_name: "Staff"

    validates :blog, presence: true
    validates :author, presence: true

    self.per_page = 10  # set will_paginate default to 10 articles


    def blog=(blog)
      blog = Blog.find(blog) unless blog.nil? || blog.is_a?(Blog)
      super(blog)
    end

    def blog_id
      blog.id
    end

  end
end
