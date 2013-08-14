class Blog::Post
  attr_accessor :matched_title, :matched_content

  searchable if: :published_at, include: [:author, :tags] do
    text :title, stored: true, boost: 2.0, more_like_this: true
    text :content, stored: true, more_like_this: true do
      body.gsub(/<[^>]*>/, '')
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

  class Search < ::Search

    attr_reader :author_id, :blog_id, :tag_ids
    attr_accessible :author_id, :blog_id, :tag_ids

    def self.model_name
      ::Search.model_name
    end

    protected
    def facet_names
      [
       [:author_id, "Author", StaffFacetDecorator],
       [:blog_id, "Blog", BlogFacetDecorator],
       [:tag_ids, "Tags", TagFacetDecorator],
      ]
    end

    class StaffFacetDecorator < ::Search::AssociationFacetDecorator
      @model_class = Staff
      @method = :name
    end

    class BlogFacetDecorator < ::Search::AssociationFacetDecorator
      @model_class = Blog
      @method = :name
    end

    class TagFacetDecorator < ::Search::AssociationFacetDecorator
      @model_class = ActsAsTaggableOn::Tag
      @method = :name
    end
  end
end
