class Blog::Post < ::Post
  include Searchable

  self.per_page = 10  # set will_paginate default to 10 articles

  # HAX: needed so that url_for works correctly for blog posts
  self.model_name.instance_variable_set(:@singular_route_key, "post")
  self.model_name.instance_variable_set(:@route_key, "posts")

  acts_as_taggable

  attr_accessible :blog, :section, :tag_list


  ##
  # Configure blog posts to be indexed by Solr
  #
  search_facet :author_ids, model: Staff
  search_facet :blog_id, model: Blog
  search_facet :tag_ids, model: ActsAsTaggableOn::Tag

  searchable if: :published_at, include: [:authors, :tags] do
    text :title, stored: true, boost: 2.0, more_like_this: true
    text :content, stored: true, more_like_this: true do
      Nokogiri::HTML(body).text
    end
    time :date, trie: true do
      published_at
    end

    text :author_names do  # Staff names rarely change
      authors.map(&:name)
    end
    integer :author_ids, multiple: true

    string :blog_id
    integer :tag_ids, multiple: true
  end

  def blog
    if @blog.nil? && section && section =~ %r[/blog/(\w+)/]
      @blog = Blog.find($1)
    end
    @blog
  end

  def blog=(blog)
    @blog = nil
    blog = blog.id if blog.is_a? Blog
    self.section = "/blog/#{blog}/"
  end

  def blog_id
    blog.id
  end

  def previous_url
    previous_id
  end

  def section_id
    blog.section_id
  end
end
