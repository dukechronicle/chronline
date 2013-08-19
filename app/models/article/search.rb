class Article
  include Searchable
  require_dependency 'search/facet_decorator'
  attr_accessor :matched_title, :matched_content

  searchable if: :published_at, include: :authors do
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
    string :section do
      section[0]
    end
  end

  class StaffFacetDecorator < ::Search::AssociationFacetDecorator
    @model_class = Staff
    @method = :name
  end

  # search_facet :author_ids, label: 'Author', decorator: StaffFacetDecorator
  # search_facet :section
end
