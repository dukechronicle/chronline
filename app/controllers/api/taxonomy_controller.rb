class Api::TaxonomyController < Api::BaseController

  def index
    render json: Taxonomy.nodes
  end

end
