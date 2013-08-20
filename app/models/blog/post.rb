class Blog
  class Post < ActiveRecord::Base
    include Postable
    include Searchable

    self.table_name = :blog_posts

    # HAX: needed so that url_for works correctly for blog posts
    self.model_name.instance_variable_set(:@singular_route_key, "post")
    self.model_name.instance_variable_set(:@route_key, "posts")

    attr_accessible :author_id, :blog, :tag_list
    serialize :blog, Blog::Serializer.new

    acts_as_taggable

    belongs_to :author, class_name: "Staff"

    validates :blog, presence: true
    validates :author, presence: true

    self.per_page = 10  # set will_paginate default to 10 articles

    ##
    # Configure blog posts to be indexed by Solr
    #
    search_facet :author_id, model: Staff
    search_facet :blog_id, model: Blog
    search_facet :tag_ids, model: ActsAsTaggableOn::Tag

    searchable if: :published_at, include: [:author, :tags] do
      text :title, stored: true, boost: 2.0, more_like_this: true
      text :content, stored: true, more_like_this: true do
        Nokogiri::HTML(body).text
      end
      time :date, trie: true do
        published_at
      end

      text :author_name do  # Staff names rarely change
        author.name
      end
      integer :author_id
      string :blog_id
      integer :tag_ids, multiple: true
    end

    def blog=(blog)
      blog = Blog.find(blog) unless blog.nil? || blog.is_a?(Blog)
      super(blog)
    end

    def blog_id
      blog.id
    end

  end
end
