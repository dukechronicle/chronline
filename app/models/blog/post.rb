class Blog::Post < ::Post
  include Searchable

  self.per_page = 10  # set will_paginate default to 10 articles

  # HAX: needed so that url_for works correctly for blog posts
  self.model_name.instance_variable_set(:@singular_route_key, "post")
  self.model_name.instance_variable_set(:@route_key, "posts")

  acts_as_taggable

  attr_accessible :blog, :tag_list

  validates_with Taxonomy::Validator, attr: :section, blog: true

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

  def blog
    section
  end

  def blog=(blog)
    blog = blog.id if blog.is_a? Blog
    self.section = "/blog/#{section}/"
  end
end
