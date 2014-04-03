# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  body       :text
#  subtitle   :string(255)
#  section    :string(255)
#  teaser     :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
#  image_id   :integer
#

class Article < Post
  include Searchable

  has_taxonomy :section, :sections

  self.per_page = 25  # set will_paginate default to 25 articles

  ##
  # Configure articles to be indexed by Solr
  #
  search_facet :author_ids, model: Staff
  search_facet :section

  searchable if: :published_at, include: :authors do
    text :title, stored: true, boost: 2.0, more_like_this: true
    text :content, stored: true, more_like_this: true do
      Nokogiri::HTML(body_text).text
    end
    time :date, trie: true do
      published_at
    end

    text :author_names do  # Staff names rarely change
      authors.map(&:name)
    end
    integer :author_ids, multiple: true

    string :section do
      section[0]
    end
  end

  def self.most_commented(limit)
    disqus = Disqus.new(ENV['DISQUS_API_KEY'])
    response = disqus.request(
      :threads, :list_hot, limit: limit, forum: ENV['DISQUS_SHORTNAME'])
    return [] if response.nil?
    slugs = response['response'].map do |thread|
      URI.parse(thread['link']).path =~ %r{/articles?/(.*)}
      [$1, thread['posts']]
    end
    posts = self.where(slug: slugs.map(&:first))
    slugs.map do |slug, comments|
      post = posts.find { |post| post.slug == slug }
      [post, comments] unless post.nil?  # TODO: this shouldn't be needed
    end.compact
  end
end
