class Article

  searchable if: :published_at, include: :authors do
    text :title, stored: true, boost: 2.0, more_like_this: true
    text :body, stored: true, more_like_this: true
    text :author_names do  # Staff names rarely change
      authors.map(&:name)
    end
    integer :author_ids, multiple: true
    string :section do
      section[0]
    end
    time :published_at, trie: true
  end

  class Search < ::Search

    attribute :author_id, type: Integer
    attribute :section, type: String

    protected
    def facet_names
      process_facets(:author_id, :section)
    end

  end

end
