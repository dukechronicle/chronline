class Search
  include ActiveModel::Conversion
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_reader :model, :query, :start_date, :end_date, :page, :per_page, :sort,
    :order, :highlight
  attr_accessible :model, :query, :start_date, :end_date, :page, :per_page,
    :sort, :order, :highlight

  # HAX: Factory method
  # http://ola-bini.blogspot.com/2007/12/code-size-and-dynamic-languages.html
  def self.new(attrs = {})
    type = self
    if (model = attrs[:model])
      attrs[:model] = model = model.constantize if model.is_a? String
      type = model.const_get(:Search)
    end
    object = type.allocate
    object.send :initialize, attrs
    object
  end

  def initialize(attrs)
    self.class.accessible_attributes.each do |attr|
      instance_variable_set "@#{attr}", attrs[attr] || attrs[attr.to_sym]
    end
    @page      ||= 1
    @per_page  ||= 25
    @sort      ||= :score
    @order     ||= :desc
    @highlight ||= false
  end

  def results
    return nil if query.blank?
    highlight_results if highlight
    request.results
  end

  def facets
    facet_names.map do |facet_name, label|
      rows = request.facet(facet_name).rows.map do |row|
        FacetDecorator.new(row)
      end
      [facet_name, label, rows]
    end
  end

  def persisted?
    false
  end

  protected
  def facet_names
    []
  end

  private
  def request
    if @request.nil?
      # TODO: include models
      types =
        if @model.nil?
          [Article]
        else
          [@model]
        end
      @request = Sunspot.search(*types) do
        paginate page: self.page, per_page: self.per_page
        order_by self.sort, self.order

        with(:date).greater_than(self.start_date) if start_date.present?
        with(:date).less_than(self.end_date) if end_date.present?

        fulltext self.query do
          if highlight
            # Fragment size 0 means return whole field
            highlight :title, fragment_size: 0
            highlight :body, max_snippets: 3, merge_contiguous_fragments: true
          end
        end

        facet_names.each do |facet_name, _|
          value = self.send facet_name
          with(facet_name, value) unless value.blank?
          facet facet_name
        end
      end
    end
    @request
  end

  def highlight_results
    request.each_hit_with_result do |hit, result|
      unless hit.highlights(:title).empty?
        result.title = highlighted(hit, :title).first.html_safe
      end

      unless hit.highlights(:body).empty?
        result.teaser =
          ("...%s..." % highlighted(hit, :body).join("...")).html_safe
      end
    end
  end

  def highlighted(hit, field)
    hit.highlights(field).map do |highlight|
      # Strip out HTML tags from matched fragments
      highlight.instance_variable_get(:@highlight).gsub!(/<[^>]*>/, '')
      highlight.format { |word| "<mark>#{word}</mark>" }
    end
  end

end
