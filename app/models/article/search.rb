class Article

  searchable if: :published_at, include: :authors do
    text :title, stored: true, boost: 2.0, more_like_this: true
    text :content, stored: true, more_like_this: true do
      body.gsub(/<[^>]*>/, '')
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

  class Search < ::Search
    require_dependency 'search/facet_decorator'

    attr_reader :author_ids, :section
    attr_accessible :author_ids, :section

    def self.model_name
      ::Search.model_name
    end

    protected
    def facet_names
      [
       [:author_ids, "Author", StaffFacetDecorator],
       [:section, "Section"]
      ]
    end

    class StaffFacetDecorator < ::Search::AssociationFacetDecorator
      @model_class = Staff
      @method = :name
    end

  end

end
