class Search
  include ActiveModel::Conversion
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_reader :model, :query, :start_date, :end_date, :page, :per_page, :sort,
    :order, :highlight
  attr_accessible :model, :query, :start_date, :end_date, :page, :per_page,
    :sort, :order, :highlight

  validates :query, presence: true


  def initialize(attrs = {})
    attrs.stringify_keys!
    self.class.accessible_attributes.each do |attr|
      instance_variable_set "@#{attr}", attrs[attr]
    end
    @model = model.constantize if model.is_a? String
    @page      ||= 1
    @per_page  ||= 25
    @sort      ||= :score
    @order     ||= :desc
    @highlight ||= false
    @end_date  ||= DateTime.now
  end

  def results
    return nil unless valid?
    highlight_results if highlight
    request.results
  end

  def facet_results
    facets.map do |name, label, decorator|
      [name, label, decorator.wrap_rows(request.facet(name).rows)]
    end
  end

  def persisted?
    false
  end

  protected
  def facets
    if @model.nil?
      []
    else
      @model.search_facets
    end
  end

  private
  def request
    if @request.nil?
      types =
        if @model.blank?
          Sunspot.searchable
        else
          [@model]
        end
      # TODO: include models
      @request = Sunspot.search(*types) do
        paginate page: self.page, per_page: self.per_page
        order_by self.sort, self.order

        with(:date).greater_than(self.start_date) unless start_date.blank?
        with(:date).less_than(self.end_date) unless end_date.blank?

        fulltext self.query do
          if highlight
            # Fragment size 0 means return whole field
            highlight :title, fragment_size: 0
            highlight :content, max_snippets: 3, merge_contiguous_fragments: true
          end
        end

        facets.each do |facet_name, _, _|
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
        result.matched_title = highlighted(hit, :title).first.html_safe
      end

      unless hit.highlights(:content).empty?
        result.matched_content =
          ("...%s..." % highlighted(hit, :content).join("...")).html_safe
      end
    end
  end

  def highlighted(hit, field)
    hit.highlights(field).map do |highlight|
      # Strip out HTML tags from matched fragments
      # highlight.instance_variable_get(:@highlight)
      highlight.format { |word| "<mark>#{word}</mark>" }
    end
  end

end
