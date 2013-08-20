class Search
  module Searchable
    require_dependency 'search/facet_decorator'
    extend ActiveSupport::Concern

    included do
      attr_accessor :matched_title, :matched_content
    end

    module ClassMethods
      def search_facet(id, label: nil, decorator: nil, model: nil, method: :name)
        attr_reader id
        attr_accessible id

        if decorator.nil? && model.present? && method.present?
          decorator = Class.new(AssociationFacetDecorator) do
            @model = model
            @method = method
          end
        end
        if label.blank?
          label = id.to_s.gsub(/_ids?$/, '').titlecase
        end
        decorator ||= FacetDecorator
        search_facets << [id, label, decorator]
      end

      def search_facets
        @facets ||= []
      end
    end
  end
end
